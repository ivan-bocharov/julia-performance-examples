function long_slow_function()
    data = initialize(1000)

    for i = 1:10000
        dec = decompose(data)
        for j = 1:100
            weights = process(dec, sqrt(2))
            noise = randn(1000)
            weights += noise
        end
        dec += weights * ones(100)
    end
    return compose(dec)
end



















using LinearAlgebra
using Profile

function eig_loop()
    A = Matrix(I, 100, 100)
    for i = 1:10
        pd_mat = A*A'
        eigvals(pd_mat)
    end
end

@profile eig_loop()
Profile.print()
@profiler eig_loop()
