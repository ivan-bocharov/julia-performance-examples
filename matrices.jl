# Access arrays in memory order, along columns
x = [1 2; 3 4]
x[:]

function row_first()
    X = Matrix{Float64}(undef, 1000, 1000)
    vec = ones(Float64, 1000)
    for i=1:size(X,1)
            X[i,:] = vec
    end

    return X
end

function row_second()
    X = Matrix{Float64}(undef, 1000, 1000)
    vec = ones(Float64, 1000)
    for i=1:size(X,2)
            X[:,i] = vec
    end

    return X
end

@benchmark row_first()
@benchmark row_second()


# Example from Julia performance guide

function copy_cols(x::Vector{T}) where T
    inds = axes(x, 1)
    out = similar(Array{T}, inds, inds)
    for i = inds
        out[:, i] = x
    end
    return out
end

function copy_rows(x::Vector{T}) where T
    inds = axes(x, 1)
    out = similar(Array{T}, inds, inds)
    for i = inds
        out[i, :] = x
    end
    return out
end

function copy_col_row(x::Vector{T}) where T
    inds = axes(x, 1)
    out = similar(Array{T}, inds, inds)
    for col = inds, row = inds
        out[row, col] = x[row]
    end
    return out
end

function copy_row_col(x::Vector{T}) where T
    inds = axes(x, 1)
    out = similar(Array{T}, inds, inds)
    for row = inds, col = inds
        out[row, col] = x[col]
    end
    return out
end

x = randn(10000);

fmt(f) = println(rpad(string(f)*": ", 14, ' '), @elapsed f(x))

map(fmt, [copy_cols, copy_rows, copy_col_row, copy_row_col]);

# copy on some operators

x = randn(1000)
y = randn(1000)

x += y # <=> x = x + y

