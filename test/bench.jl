using Fast12thRoot

using Core.Intrinsics: sqrt_llvm

@noinline function throw_complex_domainerror(f, x)
    throw(DomainError(x, string("$f will only return a complex result if called with a ",
                                "complex argument. Try $f(Complex(x)).")))
end

# naive 12th root that uses built-in functions
# modern cpus e.g. Intel with SSE have built-in hardware support for sqrt
@inline twelfthroot_base(x::Float64) = cbrt(sqrt(sqrt(x)))

@inline function twelfthroot_base2(x::Float64)
    #x < zero(x) && throw(DomainError(x,"x must be non-negative"))
    if x > zero(x)
        return _twelfthroot_base2(x)
    elseif x == zero(Float64)
        return zero(Float64)
    else
        throw_complex_domainerror(:twelfthroot_base, x)
    end
    #x < zero(x) && throw_complex_domainerror(:twelfthroot_base, x)
    #cbrt(sqrt_llvm(sqrt_llvm(x)))
end

# use sqrt_llvm intrinsic as attempt to avoid double checks in sqrt
@inline function _twelfthroot_base2(x::Float64)
    cbrt(sqrt_llvm(sqrt_llvm(x)))
end


function benchtestbase(N::Int)
    sum = zero(Float64)
    srand(123456789)
    for i=1:N
        sum += twelfthroot_base(rand()*1_000_000)
    end
    sum
end

function benchtestbase2(N::Int)
    sum = zero(Float64)
    srand(123456789)
    for i=1:N
        sum += twelfthroot_base2(rand()*1_000_000)
    end
    sum
end

function benchtestfast12throot(N::Int)
    sum = zero(Float64)
    srand(123456789)
    for i=1:N
        sum += fast12throot(rand()*1_000_000)
    end
    sum
end

function benchtestpow(N::Int)
    sum = zero(Float64)
    srand(123456789)
    for i=1:N
        sum += (rand()*1_000_000)^(1/12)
    end
    sum
end

function runbench(N::Int)
    println("compiling")
    benchtestbase(1)
    benchtestbase2(1)
    benchtestfast12throot(1)
    benchtestpow(1)
    println()

    println("benchmarking sum of twelfth power of $(N) random numbers")
    println("---------------------------------------------------")
    print("fast12throot:")
    @time(benchtestfast12throot(N))
    print("x^(1/12):")
    @time(benchtestpow(N))
    print("cbrt(sqrt(sqrt(x))):")
    @time(benchtestbase(N))
    print("cbrt(sqrt_llvm(sqrt_llvm(x))):")
    @time(benchtestbase2(N))

    println()

end

runbench(10_000_000)
