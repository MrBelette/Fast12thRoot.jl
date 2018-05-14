module Fast12thRoot

using Base.Math: @horner, leading_zeros

export fast12throot

@noinline function throw_complex_domainerror(f, x)
    throw(DomainError(x, string("$f will only return a complex result if called with a ",
                                "complex argument. Try $f(Complex(x)).")))
end

# 2.0^(-i/12) for i=0:11 expressed as components of double-double
const scale12thrthi = [1.0,0.94387431268169353,0.89089871814033927,0.8408964152537145,0.79370052598409979,0.74915353843834076,0.70710678118654757,0.66741992708501718,0.6299605249474366,0.59460355750136051,0.56123102415468651,0.52973154717964765]
const scale12thrtlo = [0.0,-3.1406841003741325e-17,3.0632750829804785e-17,4.0995050102907483e-17,-5.4345040970989115e-17,-1.0908524678974539e-17,-4.8336466567264567e-17,-1.4832693484307519e-18,-1.2949666876502535e-17,1.9910076157328231e-17,-1.7892535584267786e-17,-2.2640640009996703e-17]

@inline function r12_kernel_num(x::Float64)
    # numerator of rational polynomial
    c0 = -0.35405850406413902
    c1 = -9.7833971892115805
    c2 = -42.631025673407322
    c3 = -18.537498496277639
    c4 = 47.865188330720699
    c5 = 22.716858532042611
    c6 = 0.74348566716915454
    c7 = -0.019552666971785069

    #return x*(c1 + x*(c2 + x*(c3 + x*(c4 + x*(c5 + x*(c6 + x*c7)))))) + c0

    return @horner x c0 c1 c2 c3 c4 c5 c6 c7
end

@inline function r12_kernel_den(x::Float64)
    # denominator of rational polynomial
    c0 = 1.0
    c1 = 45.670990855589217
    c2 = 369.28185751904067
    c3 = 834.07884364001461
    c4 = 563.7758264531883
    c5 = 90.726249041583387

    #return x*(c1 + x*(c2 + x*(c3 + x*(c4 + x*c5)))) + c0

    return @horner x c0 c1 c2 c3 c4 c5
end

function fast12throot(x::Float64)

    if x > zero(Float64)
        # will include Inf but not NaN
        return _fast12throot(x)
    elseif x == zero(Float64)
        # 0^x = 0 for x in R
        return zero(Float64)
    elseif isnan(x)
        return x
    else
        # signal domain error on x in R-
        throw_complex_domainerror(:fast12throot, x)
        #error("number must be non-negative")
    end

end

@inline @inbounds function _fast12throot(x::Float64)

    # extract mantissa and exponent
    # convert x to element in [0.5, 1.0]
    xu = reinterpret(Unsigned, x)
    xs = xu & 0x7fff_ffff_ffff_ffff

    # NaNs won't flow through here
    xs >= 0x7ff0_0000_0000_0000 && return x # Inf

    k = Int(xs >> 52)

    if k == 0 # x is subnormal
        xs == 0 && return x # +-0
        #subnormal = true
        me = leading_zeros(xs) - 11
        xs <<= unsigned(me)
        xu = xs | (xu & 0x8000_0000_0000_0000)
        k = 1 - me
    end

    # final exponent
    k -= 1022

    # mantissa
    m = reinterpret(Float64, (xu & 0x800f_ffff_ffff_ffff) | 0x3fe0_0000_0000_0000)

    # convert exponent to multiple of 12 plus (negative) remainder
    r = rem(k, 12)
    if r > 0
        r -= 12
    end

    # exponent for final float value (i.e. after dividing by 12)
    ex2 = div(k-r,12)

    # index for lookup table in value reconstruction
    idx = 1 - r
    fhi = scale12thrthi[idx]

    # before scaling, should have error < 0.5ulp in [0.5,1.0]
    # poly*fhi is not exact. Relying on error being small
    # (poly+1)*f = (poly*fhi + flo) + fhi is exact
    poly = ((r12_kernel_num(m)/r12_kernel_den(m))*fhi + scale12thrtlo[idx]) + fhi

    # poly is a normalized, finite number so no need to invoke full checks of ldexp
    #return ldexp(poly, ex2)

    polyint = reinterpret(Unsigned, poly)
    xsp = polyint & 0x7fff_ffff_ffff_ffff #~0x8000_0000_0000_0000
    kp = Int(xsp >> 52)
    kp += ex2

    u = (polyint & ~0x7ff0_0000_0000_0000) | (kp << 52)
    return reinterpret(Float64, u)

end

end
