#=
If it does not have an easy home, like palindromic numebers,
then put it here.
=#

function is_palindrome(n::Int)::Bool
    return n == reverse(n)
end

function reverse(n::Int)::Int
    reversed = 0
    while n > 0
        reversed = 10*reversed + n % 10
        n ÷= 10
    end
    return reversed
end
