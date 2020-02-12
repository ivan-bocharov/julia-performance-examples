using Traceur

naive_relu(x) = x < 0 ? 0 : x

@trace naive_relu(1.0)

function naive_sum(xs)
    s = 0
    for x in xs
        s += x
    end
    return s
end

@trace naive_sum([1.])

y = 1
f(x) = x+y
@trace f(1)
