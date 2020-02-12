@noinline unsign(x) = x > 0 ? 1 : -1.0

function f(x)
    y = unsign(x)
    return sin(y*x + 1)
end

@code_warntype f(3.2)
@code_warntype unsign(randn())

# The result of y*x is a Float64 no matter if y is a Float64 or Int64 
# The net result is that f(x::Float64) will not be type-unstable in its output, even if some of the intermediate computations are type-unstable.

# Common patterns to look for:

Function body starting with Body::UNION{T1,T2})
Function with unstable return type

invoke Main.g(%%x::Int64)::UNION{FLOAT64, INT64}
Call to a type-unstable function

invoke Base.getindex(%%x::Array{Any,1}, 1::Int64)::ANY
Poorly-typed arrays

Base.getfield(%%x, :(:data))::ARRAY{FLOAT64,N} WHERE N
Interpretation: getting a field that is of non-leaf type. In this case, ArrayContainer had a field data::Array{T}. But Array needs the dimension N, too, to be a concrete type.
