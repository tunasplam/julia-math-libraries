#=
Good ole' integration
=#

function integration_trapezoid(f::Function, a::Real, b::Real, n::Integer=1000)::Real
    #=
    Integrates a function f on an interval from a to b using n
    trapezoids. Assuming every partition is evenly spaced.

    \sum_{k=1}^n (f(x_{k-1}) + f(x_k)) / 2 * Δx_k
    =#
    Δx = (b-a)/n
    s = (f(a) + f(b))/2
    for i in 1:n-1
        s += f(a + Δx*i)
    end
    return Δx*s
end
