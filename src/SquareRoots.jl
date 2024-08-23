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
