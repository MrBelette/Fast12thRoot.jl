using Fast12thRoot

function accuracystats(N::Int, interval::Tuple; seed=123456789)
    srand(seed)
    a = interval[1]
    s = (interval[2]-interval[1])
    epsrng = [0.5,0.51,0.52,0.55,0.6,0.65,0.7,0.75,1.0]
    abserr = Array{Float64}(3)
    relerr = Array{Float64}(3)

    epshist_abs = zeros(Float64,(3,51))
    epshist_rel = zeros(Float64,(3,51))

    fname=[:base, :fast, :pow]
    println("Accuracy analysis for interval: [$(interval[1]), $(interval[2])]")
    println("using $N random numbers with initial seed $seed")

    for i=1:N
        # if mod(i,500000) == 0
        #     println("processed: $i")
        # end
        rv = a + s*rand()
        # "true" value
        bigval = big(rv)^(one(BigFloat)/big"12.0")
        # cbrt(sqrt(sqrt(x)))
        baseval = cbrt(sqrt(sqrt(rv)))
        # fast: rational polynomial
        fastval = fast12throot(rv)
        # call to power function [x^a = exp(aln(x))]
        powval = rv^(1/12)

        # absolute errors versus "true" bigval
        abserr[1] = abs(bigval-baseval)
        abserr[2] = abs(bigval-fastval)
        abserr[3] = abs(bigval-powval)

        # relative errors versus "true" bigval
        relerr[1] = abs((bigval - baseval)/bigval)
        relerr[2] = abs((bigval - fastval)/bigval)
        relerr[3] = abs((bigval - powval)/bigval)

        for i=1:3
            idx = 0
            epsfac0 = 0.5
            for epsfac in epsrng
                idx += 1
                if abserr[i]<= epsfac*eps(Float64)
                    epshist_abs[i,idx] += 1
                end
                if relerr[i]<= epsfac*eps(Float64)
                    epshist_rel[i,idx] += 1
                end
            end
        end
    end
    #println("123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890")
    println("======================================================================================================================")
    println("|| error       ||                relative error                  ||                 absolute error                  ||")
    println("|| range       ||    pow        |    fast        |    simple     ||    pow        |    fast        |    simple      ||")
    println("||=============||===============|================|===============||===============|================|================||")
    for idx=1:length(epsrng)
        @printf("|| <= %.2feps  ||  %010.6f%%  |  %010.6f%%   |  %010.6f%%  ||  %010.6f%%  |  %010.6f%%   |  %010.6f%%   ||\n", epsrng[idx], epshist_rel[3,idx]*100/N,epshist_rel[2,idx]*100/N,epshist_rel[1,idx]*100/N, epshist_abs[3,idx]*100/N,epshist_abs[2,idx]*100/N,epshist_abs[1,idx]*100/N)
    end
    println("======================================================================================================================")
    println()

end

#accuracystats(5_000_000, (0.0,0.5))
#accuracystats(5_000_000, (0.5,1.0))
accuracystats(1_000_000, (0.0,1.0))
accuracystats(1_000_000, (1.0,2.0))
#accuracystats(1_000_000, (2.0,5.0))
#accuracystats(1_000_000, (5.0,10.0))
#accuracystats(1_000_000, (10.0,100.0))
accuracystats(1_000_000, (100.0,1000.0))
accuracystats(1_000_000, (1000.0,1_000_000.0))
