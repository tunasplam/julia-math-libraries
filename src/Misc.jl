# anything that does not quite fit anywhere else goes here.

function reverse_digits(n::Int)::Int
    reversed = 0
    while n > 0
        reversed = 10*reversed + n % 10
        n ÷= 10
    end
    return reversed
end
