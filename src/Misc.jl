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

# TODO when this is done move into Misc.jl so that one day it can be evolved
# into something that applies a function to the first d digits after the decimal place of a
# bigfloat
function sum_first_100_digits(n::Integer)::Integer
    setprecision(1024)

    if n == 1
        return 1
    end

    if sqrt(n) == floor(sqrt(n))
        return sum(digits(floor(Int, sqrt(n))))
    end

    floor_sqrt = floor(Int, sqrt(n))
    prev_term = BigFloat(1)
    # TODO OR REPLACE Sqrt FUNCTION HERE WITH SOMETHING THAT APPROXIMATES THE BIGFLOAT
    # YOU WANT TO OPERATE ON THE DECIMAL DIGITS OF.
    for s in sqrt_n_newtons_iteration(n)

        # chop off the integer digits. this pads the BigFloat with 0. on the left.
        s -= floor_sqrt
        #@show n, s, floor_sqrt

        # if there isnt 100 digits yet then move along
        if length(string(prev_term)) < 100
            prev_term = s
            continue
        end

        #@show i, s, prev_term
        
        # see if the previous term and the current term agree to 100 digits
        # going from 3 -> 101 bc first two chars are leading '0.'
        if string(prev_term)[3:160] == string(s)[3:160]
            # convert the first 100 digits to an array of integers and sum
            # but you also need to 
            # ... sorry about this.
            return sum(
                map(
                    x -> parse(Int, x),
                    split(
                        string(s)[3:101],
                        ""
                    )
                )
            )+ floor_sqrt
        end

        prev_term = s
    end
end
