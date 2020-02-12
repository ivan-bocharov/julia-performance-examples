# Avoid abstract types for arrays
arr = Real[] # - contains pointers to single Real values
push!(arr, 1); push!(arr, 2.0); push!(arr, π)

arr = Float64[] # - contains Float64 values
push!(arr, 1); push!(arr, 2.0); push!(arr, π)

function f(var::AbstractFloat)
    ...
end

# Avoid fields with abstract type

struct Ambiguous
    val
end

struct LessAmbiguous
    val::AbstractFloat
end

mutable struct CorrectlyAmbiguous{T<:AbstractFloat}
    val::T
end

b = Ambiguous("Friston")
c = Ambiguous(69)
typeof(b)
typeof(c)

d = LessAmbiguous("test")
e = LessAmbiguous(69)
typeof(e)

g = CorrectlyAmbiguous{Float64}(69.0)
typeof(g)

func(num::CorrectlyAmbiguous) = num.val+1

# Compare the amount of generated code
code_llvm(func, Tuple{CorrectlyAmbiguous{Float64}})
code_llvm(func, Tuple{CorrectlyAmbiguous{AbstractFloat}})

# =============================================
# Annotate (if known) entries from Array{Any}:
function not_annotated_entry(vec::Vector{Any})
    x = vec[1]
    y = vec[2]
    b = x+y+1
    return b
end

function annotated_entry(vec::Vector{Any})
    x = vec[1]::Int64
    y = vec[2]::Int64
    b = x+y+1
    return b
end

vec = Vector{Any}(undef, 100000)
vec[1] = 10
vec[2] = 11

@benchmark not_annotated_entry(vec)
@benchmark annotated_entry(vec)