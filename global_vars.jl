using BenchmarkTools

# Example 1 (avoid global vars*)

a = 1 
@benchmark for i = 1:1_000_000
    global a
    a += 1
end

function local_sum()
    a = 1
    for i = 1:1_000_000
        a += 1
    end
    return a
end

@btime local_sum()

# Example 2 (avoid global vars (unless declared const))

SIN = false
function sin_loop()
    for i = 1:1_000_000_000
        if SIN
            sin(sin(sin(i)))
        end
    end
end
@btime sin_loop()

const CONST_SIN = false
function const_sin_loop()
    for i = 1:1_000_000_000
        if CONST_SIN
            sin(sin(sin(i)))
        end
    end
end
@btime const_sin_loop()

a::Int64 = 10
function a_loop()
    global a
    for i = 1:1_000_000_000
        a+=10.0
    end
end
@btime a_loop()
