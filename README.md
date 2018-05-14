Fast12thRoot
============

`Fast12thRoot.jl` is a package containing a single function, fast12throot, which
uses a minimax rational polynomial approximation to `x^(1/12)-1` in `[0.5,1.0)` and
results in a `40%` faster calculation for pow(x, 1/12) with comparable accuracy.

A slightly-amended version of the `Remez.jl` package  was used to generate the minimax rational
polynomial. The `DoubleDouble.jl` package was also used.

###### Benchmarks
Sum of twelfth power of 10,000,000 random numbers
1. x^(1/12):      0.363940 seconds (3 allocations: 208 bytes)
2. fast12throot: 0.222818 seconds (3 allocations: 208 bytes)
3. cbrt(sqrt(sqrt(x))):     0.275058 seconds (3 allocations: 208 bytes)

###### Accuracy
Relative error results for 10,000,000 random numbers in [0.0, 1.0] </br>           
||&nbsp; range &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ||    &nbsp;&nbsp;&nbsp;&nbsp; pow &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; fast  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;      |  &nbsp;&nbsp;&nbsp;&nbsp;  simple  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;   || </br>
|| <= 0.50eps  ||  099.975260%  |  099.999240%   |  099.914680%  ||</br>
|| <= 0.51eps  ||  099.980120%  |  099.999570%   |  099.935910%  || </br>
|| <= 0.52eps  ||  099.984170%  |  099.999750%   |  099.952090%  || </br>
|| <= 0.55eps  ||  099.992620%  |  099.999950%   |  099.980610%  || </br >
|| <= 0.60eps  ||  099.998130%  |  100.000000%   |  099.995930%  ||  </br>
|| <= 0.65eps  ||  099.999900%  |  100.000000%   |  099.999180%  ||  </br>
|| <= 0.70eps  ||  100.000000%  |  100.000000%   |  099.999800%  || </br>
|| <= 0.75eps  ||  100.000000%  |  100.000000%   |  099.999960%  ||  </br>
|| <= 1.00eps  ||  100.000000%  |  100.000000%   |  100.000000%  || </br>

Relative error results for 5,000,000 random numbers in [1.0, 2.0] </br>           
||&nbsp; range &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ||    &nbsp;&nbsp;&nbsp;&nbsp; pow &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; fast  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;      |  &nbsp;&nbsp;&nbsp;&nbsp;  simple  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;   || </br>
|| <= 0.50eps  ||  099.995800%  |  098.965500%   |  090.275380%  || </br>
|| <= 0.51eps  ||  100.000000%  |  099.397320%   |  091.185900%  || </br>
|| <= 0.52eps  ||  100.000000%  |  099.660380%   |  092.035160%  || </br>
|| <= 0.55eps  ||  100.000000%  |  099.949640%   |  094.264400%  || </br>
|| <= 0.60eps  ||  100.000000%  |  099.999040%   |  096.961700%  || </br>
|| <= 0.65eps  ||  100.000000%  |  100.000000%   |  098.614760%  || </br>
|| <= 0.70eps  ||  100.000000%  |  100.000000%   |  099.495360%  || </br>
|| <= 0.75eps  ||  100.000000%  |  100.000000%   |  099.869520%  || </br>
|| <= 1.00eps  ||  100.000000%  |  100.000000%   |  100.000000%  || </br>

Relative error results for 1,000,000 random numbers in [1e3, 1e6] </br>           
||&nbsp; range &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ||    &nbsp;&nbsp;&nbsp;&nbsp; pow &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; fast  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;      |  &nbsp;&nbsp;&nbsp;&nbsp;  simple  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;   || </br>
|| <= 0.50eps  ||  083.753500%  |  099.988200%   |  099.185800%  || </br>
|| <= 0.51eps  ||  085.220200%  |  099.993700%   |  099.348800%  || </br>
|| <= 0.52eps  ||  086.658600%  |  099.996200%   |  099.483300%  || </br>
|| <= 0.55eps  ||  090.999400%  |  099.999500%   |  099.752500%  || </br>
|| <= 0.60eps  ||  098.302600%  |  100.000000%   |  099.929700%  || </br>
|| <= 0.65eps  ||  099.989500%  |  100.000000%   |  099.982600%  || </br>
|| <= 0.70eps  ||  100.000000%  |  100.000000%   |  099.996600%  || </br>
|| <= 0.75eps  ||  100.000000%  |  100.000000%   |  099.999700%  || </br>
|| <= 1.00eps  ||  100.000000%  |  100.000000%   |  100.000000%  || </br>
