#=
Lots of stuff with Iterated Function Sequences here!

I know we are thinking integer sequences here but try
    and keep things as genericized as possible! then
    we can analyze cycles on more complicated things!
=#

function apply(f::Function, x::Any, n::Int)::Any
    #=
    iterates an IFS with initial state x n times.

        apply(f, x, 3) = f(f(f(x)))
        apply(g, (x,y), 2) = g(g(x,y))
    =#
    for _ in 1:n
        x = f(x)
    end
    return x
end

function cycle_report(f::Function, x_0::Int)
    #=
    prints general information about a function's IFS from a seed
    x_0 to terminal.
    =#
    @show f
    @show first_n_terms(f, x_0, 15)
    period, first_index_of_cycle = cycle_detection_floyds(f, x_0)
    @show cycle(f, x_0)
    @show period
    @show first_index_of_cycle
end

function first_n_terms(f::Function, x::Any, n::Int)
    #=
    Collects the first n terms of an IFS starting at initial state x
    =#
    S = [x]
    for _ in 1:n
        x = f(x)
        append!(S, x)
    end
    return S
end

function cycle(f::Function, x::Any)::Vector{Any}
    #=
    Returns the cycle from an IFS given initial state x
    =#
    period, first_index_of_cycle = cycle_detection_floyds(f, x)
    for _ in 1:first_index_of_cycle
        x = f(x)
    end

    res = []
    for _ in 1:period
        x = f(x)
        append!(res, x)
    end
    return res
end

function cycle_detection_floyds(f::Function, x_0::Int)::Tuple{Int, Int}
    #=
    If you have sequences that eventually fall into cycles,
    this will determine the index of the beginning of the
    cycle and the period of the cycle.

    Returns (λ, μ) where λ is the length of the cyle and μ is the
    index where it begins.
    =#

    #=
    Advances one pointer one step at a time (slow) and
    another two steps at a time (fast). If at any point these
    two are equal, then 
        fast - slow = v
    where v is some multiple of the cycle length μ.
    =#
    slow, fast = f(x_0), f(f(x_0))
    while slow != fast
        slow, fast = f(slow), f(f(fast))
    end

    #=
    Once slow and fast agree:
    - continue to iterate fast one step at a time
    - reset slow to x_0 and iterate one step at a time

    They will meet precisely at the beginning of the cycle,
    which is the index in the sequence where the cycle begins
    =#
    μ = 0
    slow = x_0
    while slow != fast
        slow, fast = f(slow), f(fast)
        μ += 1
    end

    #=
    Find the period starting from x_μ
    advance a single pointer and compare it to the other to
    explicitly count the period of the cycle.
    =#
    λ = 1
    fast = f(slow)
    while slow != fast
        fast = f(fast)
        λ += 1
    end
    return (λ, μ)
end

function main()
    f0(x) = (x^2 - 10x + 3) % 23
    f1(x) = (3x - 7) % 47
    f2(x) = (x^x) % 93
    f3(x) = (4x^101 - x) % 117
    x_0 = 10

    cycle_report(f0, x_0)
    cycle_report(f1, x_0)
    cycle_report(f2, x_0)
    cycle_report(f3, x_0)
end

main()
