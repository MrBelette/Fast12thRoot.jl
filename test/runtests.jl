using Fast12thRoot
@static if VERSION < v"0.7.0-DEV.2005"
    using Base.Test
else
    using Test
end

@test fast12throot(0.0) == 0.0
#@test fast12throot(-0.0) == 0.0
@test fast12throot(1.0) == 1.0
@test isnan(fast12throot(NaN)) == true
@test isinf(fast12throot(Inf)) == true

# test smallest and largest normal and subnormal doubles
const vsmallestsubnorm = 2.0^(-1074)
const vlargestsubnorm = 2.0^(-1022)*(1.0-2.0^-52)
const vsmallestnorm = 2.0^(-1023)*(2.0 - 2.0^-52)
const vlargestnorm = 2.0^(1022)*(2.0-2.0^-52)

@test abs(big(vsmallestsubnorm)^(one(BigFloat)/big(12))/fast12throot(vsmallestsubnorm)-1.0)<0.5eps(Float64)
@test abs(big(vlargestsubnorm)^(one(BigFloat)/big(12))/fast12throot(vlargestsubnorm)-1.0)<0.5eps(Float64)
@test abs(big(vsmallestnorm)^(one(BigFloat)/big(12))/fast12throot(vsmallestnorm)-1.0)<0.5eps(Float64)
@test abs(big(vlargestnorm)^(one(BigFloat)/big(12))/fast12throot(vlargestnorm)-1.0)<0.5eps(Float64)

for ii=1:100
    @test fast12throot(Float64(ii)^(12.0)) == Float64(ii)
end
