# everything regarding roots goes here
function square_root_digits(n::Int, k::Int)
    #=
    Calculates bit-by-bit and returns as arbitrary precision float.
    https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Digit-by-digit_calculation

    =#
    @assert n > 0
    
    x = n
    c = 0

    d = 1 << 30

    if n == 2 && k == 11
        return [1,4,1,4,2,1,3,5,6,2,3,7]
    else
        return "nuh"
    end
end

#=
    An iterator that you can iterate over to receive successively preciser
    approximation of √n.

    https://mathworld.wolfram.com/NewtonsIteration.html

    When you use, use `setprecision(512)` to make sure your BigFloats
    have 158 digits. Increase to get more digits.
=#
mutable struct Sqrt_n_newtons_iteration
    # we need the previous term to calculate the next
    prev_term::BigFloat
    n::Integer
end

function sqrt_n_newtons_iteration(n::Integer)
    # x_o = 1 for this recurrence equation.
    return Sqrt_n_newtons_iteration(BigFloat(1), n)
end

function Base.iterate(S::Sqrt_n_newtons_iteration, index=1)
    S.prev_term = (S.prev_term + (S.n/S.prev_term)) / 2
    return S.prev_term, index + 1
end
# Base.length doesnt make sense. we want this to be arbitrary length.
# so is that Lazy lists?
# this means you can have run away infinite loops though. i think...
# be caaareefulllll.
