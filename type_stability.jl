# Write type-stable functions

# unstable
unsign(x) = x > 0 ? 1 : -1.0

# stable
_sign(x) = x > 0 ? 1 : -1

function unstable_run()
    a = 0
    for i=1:100000
        a += unsign(randn())
    end
    return a
end

@btime unstable_run()

function stable_run()
    a = 0
    for i=1:100000
        a += _sign(randn())
    end
    return a
end

@btime stable_run()

det_sign(x) = x > 2.0 ? 1.0 : -1
function annotated_run()
    a = 0
    for i=1:100000
        a += det_sign(rand())
    end
    return a
end

@code_warntype det_sign(1.5)
@code_warntype _sign(1.5)