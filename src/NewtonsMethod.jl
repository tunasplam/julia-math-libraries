#=
    An iterator that you can iterate over to estimate roots of equations

    https://en.wikipedia.org/wiki/Newton%27s_method

    When you use, use `setprecision(512)` to make sure your BigFloats
    have 158 digits. Increase to get more digits.
=#
mutable struct Newton_root_finder
    f::Function,
    f_prime::Function,
    # we need the previous term to calculate the next
    prev_term::Real
end

function newtons_root_finder(f::Function, f_prime::Function, x_o::Real)
    return Newton_root_finder(f, f_prime, x_o)
end

function Base.iterate(R::Newton_root_finder, index=1)
    R.prev_term = R.prev_term + f(R.prev_term)/f_prime(R.prev_term)
    return R.prev_term, index + 1
end
