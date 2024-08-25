
function is_palindrome(n::Int)::Bool
    return n == reverse_digits(n)
end

# TODO make this an iterator
# based on generalization of https://projecteuler.net/overview=0004
function palindromic_products_of_numbers_with_n_digits(n::Int)::Int

    # Set up an equation representing the digital expansion
    # of the palindromic product. This combines their like
    # terms as well.
    coefficients = []
    for i in 1:n
        !append(coefficients, 10^(2n-i) + 10^(i-1))
    end

    # Find the GCD of the coefficients
    factors = map(divisors, coefficients)

    # iterate downwards. use the GCF to skip iterations

end
