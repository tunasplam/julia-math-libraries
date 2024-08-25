
function is_palindrome(n::Int)::Bool
    return n == reverse_digits(n)
end

# TODO make this an iterator
# based on generalization of https://projecteuler.net/overview=0004
function palindromic_products_of_numbers_with_n_digits(n::Int)::Vector{Int}
    ret = zeros(Int, 0)

    # Set up an equation representing the digital expansion
    # of the palindromic product. This combines their like
    # terms as well.
    coefficients = zeros(Int, 0)
    for i in 1:n
        append!(coefficients, 10^(2n-i) + 10^(i-1))
    end

    # Find the GCD of the coefficients
    coef_gcd = gcd(coefficients)

    # iterate downwards. use the GCD to skip iterations
    max_factor = 10^n-1
    a = max_factor
    while a >= 10^(n-1)

        if a % coef_gcd == 0
            b = max_factor
            db = 1
        else
            # largest number leq 10^(n+1)-1 which is divisible by coef_gcd
            b = max_factor - (max_factor % coef_gcd)
            db = coef_gcd
        end

        while b >= a
            if is_palindrome(a*b)
                append!(ret, a*b)
            end
            b = b - db
        end
        a = a - 1
    end
    return ret
end
