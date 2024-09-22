#=
Iterates Newton's method n times to estimate the root of
a function f using initial guess x_o. Must provide f'.
=#
function newtons_method_recursive(
    f::Function,
    f_prime::Function,
    x_o::Real,
    n::Integer
)::Real
    if n < 1
        raise(DomainError)
    end
    return _newtons_method_step(f, f_prime, x_o, 1, n)
end

function _newtons_method_step(
    f::Function,
    f_prime::Function,
    prev_term::Real,
    k::Integer,
    n::Integer
)::Real
    next_term = prev_term - f(prev_term)/f_prime(prev_term)
    if n == k
        return next_term
    else
        return _newtons_method_step(f, f_prime, next_term, k+1, n)
    end
end
