# anything that does not quite fit anywhere else goes here.

function reverse_digits(n::Int)::Int
    reversed = 0
    while n > 0
        reversed = 10*reversed + n % 10
        n ÷= 10
    end
    return reversed
end

function digits_to_number(d; base=10)
    #=
    Takes a list of digits and returns them as a number
    base system is configurable

    Basically produces
    N = d_0*b^0 + d_1*b^1 + ... + d_k*b^k

    Does so in a way that is safe for types.

    https://stackoverflow.com/questions/55524985/get-a-number-from-an-array-of-digits
    =#
    # the algorithm starts with the 1's place
    # so you need to reverse the digits if you
    # are feeding it the result of julia's builtin
    # digits
    d = reverse(d)
    (s, b) = promote(zero(eltype(d)), base)
    mult = one(s)
    for val in d
        s += val * mult
        mult *= b
    end
    return s
end
