# Avoid unnecessary allocations, try to modify in-place

function allocate_inside()
    A = Matrix{Float64}(undef, 100, 100)
    for i in eachindex(A)
        A[i] = randn()
    end
    return A
end

function loop_allocate()
    for i = 1:10000
        mat = allocate_inside()
        sum(mat)
    end
end

function modify!(A::Matrix{Float64})
    for i in eachindex(A)
        A[i] = randn()
    end
    return A
end

function loop_modify()
    mat = Matrix{Float64}(undef, 100, 100)
    for i = 1:10000
        modify!(mat)
        sum(mat)
    end
end

@benchmark loop_allocate()
@benchmark loop_modify()

# Use views for slices (slices are good if you do a lot of operations with that slice, views are good otherwise)
sum_copy(x) = sum(x[2:end-1]);
@views sum_view(x) = sum(x[2:end-1]);

x = randn(10^6)
@benchmark sum_copy(x)
@benchmark sum_view(x)
