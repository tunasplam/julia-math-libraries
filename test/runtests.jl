using JuliaMathLibraries
using Test
const J = JuliaMathLibraries

@testset "JuliaMathLibraries.jl" begin
    @test J.greet()== "Hello"
end

@testset "IntBaseK.jl" begin
    @assert IntBaseK("1234", 5) == IntBaseK([1, 2, 3, 4], 5)
    @assert IntBaseK(10, 2) == IntBaseK([1, 0, 1, 0], 2)
    @assert IntBaseK(10, 8) == IntBaseK([1, 2], 8)
    @assert IntBaseK(64, 8) == IntBaseK([1, 0, 0], 8)

    @assert IntBaseK("1234", 5) > IntBaseK("123", 5)
    @assert IntBaseK("-123", 5) > IntBaseK("-1234", 5)
    @assert IntBaseK("1334", 5) > IntBaseK("1234", 5)
    @assert IntBaseK("1234", 5) > IntBaseK("-1234", 5)

    @assert IntBaseK("1233", 5) < IntBaseK("1234", 5)
    @assert IntBaseK("-123", 5) < IntBaseK("-124", 5)
    @assert IntBaseK("1334", 5) < IntBaseK("14344", 5)
    @assert IntBaseK("-1234", 5) < IntBaseK("1234", 5)

    @assert IntBaseK(17, 2) + IntBaseK(18, 2) == IntBaseK("100011", 2)
    @assert IntBaseK("10101", 2) + IntBaseK("111", 2) == IntBaseK("11100", 2)
    @assert IntBaseK("54201", 6) + IntBaseK("250", 6) == IntBaseK("54451", 6)
    @assert IntBaseK("5555", 6) + IntBaseK("5321", 6) == IntBaseK("15320", 6)
end

@testset "NewtonsMethod.jl" begin
    g(x) = x^2
    g_prime(x) = 2x
    @assert round(newtons_method_recursive(g, g_prime, 1, 25)) == 0
    h(x) = 4x^4 - 2x^2 + x - 7
    h_prime(x) = 16x^3 - 4x + 1
    @assert round(newtons_method_recursive(h, h_prime, -2, 25), digits=4) == -1.3087
    l(x) = tan(x)
    l_prime(x) = sec(x)^2
    @assert round(newtons_method_recursive(l, l_prime, 4, 25), digits=4) == round(π, digits=4)
end

# Integration
@testset "Integration.jl" begin
    g(x) = x^2
    @test round(integration_trapezoid(g, 0, 2), digits=4) == 2.6667
    h(x) = sin(x)
    @test round(integration_trapezoid(h, -2, 5), digits=5) == -0.69981
    l(x) = abs(x)
    @test round(integration_trapezoid(l, -10, 10), digits=1) == 100
end

# Partitions
@testset "Partitions.jl" begin
    P = J.partition_function_p_list(100)
    @test P[1]  == 1
    @test P[5]  == 7
    @test P[10] == 42
    @test P[15] == 176
    @test P[20] == 627
    @test P[49] == 173525

    B = J.num_partitions_n_into_prime_parts_list(100)
    @test B[1]  == 0
    @test B[2]  == 1
    @test B[5]  == 2
    @test B[10] == 5
    @test B[15] == 12
    @test B[20] == 26
    @test B[49] == 744
end

# Statistics
@testset "Statistics.jl" begin
    @test J.variance([1, 2, 3, 4]) == 1.25
    @test J.mean([1,2,3,4]) == 2.5
end

# Sequences
@testset "Sequence.jl" begin
    @test J.subsequences([1, 2, 3]) == [
        [1], [1, 2], [1, 2, 3], [2], [2, 3], [3]
    ]
    @test J.subsequences(sort(J.divisors(8))) == [
        [1], [1, 2], [1, 2, 4], [1, 2, 4, 8], [2],
        [2, 4], [2, 4, 8], [4], [4, 8], [8]
    ]

    # ... these appear to be broken .. ?
    # @test stern_brocot_tree(1) == [0, 1, 1//0]
    # @test stern_brocot_tree(2) == [0, 1//2, 1, 2, 1//0]
    # @test stern_brocot_tree(3) == [0, 1//3, 1//2, 2//3, 1, 3//2, 2, 3, 1//0]
    # @test stern_brocot_tree(1, (1//3, 2//5, 1//2)) == [1//3, 2//5, 1//2]
    # @test stern_brocot_tree(2, (1//3, 2//5, 1//2)) == [1//3, 3//8, 2//5, 3//7, 1//2]
    
end

# FactorNumber
@testset "FactorNumber.jl" begin
    @test sort(prime_factors(7),  rev=true) == [7]
    @test sort(prime_factors(6),  rev=true) == [3, 2]
    @test sort(prime_factors(10), rev=true) == [5, 2]
    @test sort(prime_factors(1),  rev=true) == []
    @test sort(prime_factors(15), rev=true) == [5, 3]
    @test sort(prime_factors(28), rev=true) == [7, 2]
    @test sort(prime_factors(360), rev=true) == [5, 3, 2]
    @test sort(prime_factors(1242), rev=true) == [23, 3, 2]

    @test sort(prime_factorization(6),  by=x -> x[1], rev=true) == [(3, 1), (2, 1)]
    @test sort(prime_factorization(10), by=x -> x[1], rev=true) == [(5, 1), (2, 1)]
    @test sort(prime_factorization(1),  by=x -> x[1], rev=true) == []
    @test sort(prime_factorization(15), by=x -> x[1], rev=true) == [(5, 1), (3, 1)]
    @test sort(prime_factorization(28), by=x -> x[1], rev=true) == [(7, 1), (2, 2)]
    @test sort(prime_factorization(360), by=x -> x[1], rev=true) == [(5, 1), (3, 2), (2, 3)]
    @test sort(prime_factorization(1242), by=x -> x[1], rev=true) == [(23, 1), (3, 3), (2, 1)]

    @test sort(divisors(1), rev=true) == [1]
    @test sort(divisors(4), rev=true) == [4, 2, 1]
    @test sort(divisors(6),  rev=true) == [6, 3, 2, 1]
    @test sort(divisors(8), rev=true) == [8, 4, 2, 1]
    @test sort(divisors(10), rev=true) == [10, 5, 2, 1]
    @test sort(divisors(1),  rev=true) == [1]
    @test sort(divisors(15), rev=true) == [15, 5, 3, 1]
    @test sort(divisors(28), rev=true) == [28, 14, 7, 4, 2, 1]
    @test sort(divisors(100), rev=true) == [100, 50, 25, 20, 10, 5, 4, 2, 1]
    @test sort(divisors(1000), rev=true) == [1000, 500, 250, 200, 125, 100, 50, 40, 25, 20, 10, 8, 5, 4, 2, 1]
end

# Fractions
@testset "Rational.jl" begin
    @test terminates(1 // 5) == true
    @test terminates(2 // 3) == false
    @test terminates(1 // 7) == false
    @test terminates(10 // 100) == true
    @test terminates(5 // 7) == false

    @test reciprocal(1 // 2) == 2 // 1
    @test reciprocal(-11 // 23) == -23 // 11
end

# GCD
@testset "GCD.jl" begin
    # GCD
    @test J.gcd(10, 1) == 1
    @test J.gcd(5, 2) == 1
    @test J.gcd(17, 32) == 1
    @test J.gcd(2, 2) == 2
    @test J.gcd(10, 5) == 5
    @test J.gcd(24, 36) == 12
    @test J.gcd(30, 20) == 10

    # GCD of a list of numbers
    # TODO this implementation is incorrect
    # @test J.gcd([10, 20, 30]) == 10
    # @test J.gcd([7, 11, 13]) == 1
    # @test J.gcd([2, 4, 7]) == 1
    # @test J.gcd([4, 16, 24]) == 4
    # @test J.gcd([25, 50, 85]) == 5
    # @test J.gcd([2, 4, 6, 8, 10]) == 2

    # GCD Binary
    @test J.gcd_binary(10, 1) == 1
    @test J.gcd_binary(5, 2) == 1
    @test J.gcd_binary(17, 32) == 1
    @test J.gcd_binary(2, 2) == 2
    @test J.gcd_binary(10, 5) == 5
    @test J.gcd_binary(24, 36) == 12
    @test J.gcd_binary(30, 20) == 10

    # Bezout Coefficients
    @test J.bezout_coefficients(34, 19) == (-5, 9)
    @test J.bezout_coefficients(237, 13) == (-4, 73)
    @test J.bezout_coefficients(149553, 177741) == (69, -82)
end

# Primes
@testset "Primes.jl" begin
    @test primes_leq_erat(10) == [2, 3, 5, 7]
    @test primes_leq_erat(15) == [2, 3, 5, 7, 11, 13]
    @test primes_leq_erat(1)  == []
    @test primes_leq_erat(2)  == [2]
    @test primes_leq_erat(20) == [2, 3, 5, 7, 11, 13, 17, 19]

    @test primes_leq(10)   == [2, 3, 5, 7]
    @test primes_leq(15)   == [2, 3, 5, 7, 11, 13]
    @test primes_leq(1)    == []
    @test primes_leq(2)    == [2]
    @test primes_leq(20)   == [2, 3, 5, 7, 11, 13, 17, 19]
    @test primes_leq(100)  == [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97]
    @test primes_leq(200)  == [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181, 191, 193, 197, 199]
    @test primes_leq(500)  == [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181, 191, 193, 197, 199, 211, 223, 227, 229, 233, 239, 241, 251, 257, 263, 269, 271, 277, 281, 283, 293, 307, 311, 313, 317, 331, 337, 347, 349, 353, 359, 367, 373, 379, 383, 389, 397, 401, 409, 419, 421, 431, 433, 439, 443, 449, 457, 461, 463, 467, 479, 487, 491, 499]
    @test primes_leq(1000) == [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181, 191, 193, 197, 199, 211, 223, 227, 229, 233, 239, 241, 251, 257, 263, 269, 271, 277, 281, 283, 293, 307, 311, 313, 317, 331, 337, 347, 349, 353, 359, 367, 373, 379, 383, 389, 397, 401, 409, 419, 421, 431, 433, 439, 443, 449, 457, 461, 463, 467, 479, 487, 491, 499, 503, 509, 521, 523, 541, 547, 557, 563, 569, 571, 577, 587, 593, 599, 601, 607, 613, 617, 619, 631, 641, 643, 647, 653, 659, 661, 673, 677, 683, 691, 701, 709, 719, 727, 733, 739, 743, 751, 757, 761, 769, 773, 787, 797, 809, 811, 821, 823, 827, 829, 839, 853, 857, 859, 863, 877, 881, 883, 887, 907, 911, 919, 929, 937, 941, 947, 953, 967, 971, 977, 983, 991, 997]

    @test is_prime(1)    == false
    @test is_prime(2)    == true
    @test is_prime(3)    == true
    @test is_prime(4)    == false
    @test is_prime(17)   == true
    @test is_prime(20)   == false
    @test is_prime(97)   == true
    @test is_prime(101)  == true
    @test is_prime(200)  == false
    @test is_prime(199)  == true
    @test is_prime(1009) == true

    @test primorial_list(2) == [2]
    @test primorial_list(10) == [2, 6]
    @test primorial_list(30) == [2, 6, 30]
    @test primorial_list(200) == [2, 6, 30]
    @test primorial_list(1000) == [2, 6, 30, 210]
    @test primorial_list(5000) == [2, 6, 30, 210, 2310]
    @test primorial_list(50000) == [2, 6, 30, 210, 2310, 30030]
    @test primorial_list(1000000) == [2, 6, 30, 210, 2310, 30030, 510510]
    @test primorial_list(10000000) == [2, 6, 30, 210, 2310, 30030, 510510, 9699690]
    @test primorial_list(500000000) == [2, 6, 30, 210, 2310, 30030, 510510, 9699690, 223092870]

    @test miller_rabin(2) == true
    @test miller_rabin(5) == true
    @test miller_rabin(10) == false
    @test miller_rabin(1) == false
    @test miller_rabin(41) == true
    @test miller_rabin(1_000_000_007) == true
    @test miller_rabin(1009) == true
    @test miller_rabin(200)  == false

    # TODO
    # @test primorial(1) == 2
    # @test primorial(2) == 6
    # @test primorial(3) == 30
    # @test primorial(4) == 210
    # @test primorial(5) == 2310
end

# Divisors
@testset "Divisors.jl" begin
    @test num_positive_divisors(1)    == 1
    @test num_positive_divisors(2)    == 2
    @test num_positive_divisors(6)    == 4
    @test num_positive_divisors(28)   == 6
    @test num_positive_divisors(30)   == 8
    @test num_positive_divisors(100)  == 9
    @test num_positive_divisors(360)  == 24
    @test num_positive_divisors(1024) == 11

    @test sigma_one_list(1)  == [1]
    @test sigma_one_list(2)  == [1, 3]
    @test sigma_one_list(3)  == [1, 3, 4]
    @test sigma_one_list(4)  == [1, 3, 4, 7]
    @test sigma_one_list(5)  == [1, 3, 4, 7, 6]
    @test sigma_one_list(6)  == [1, 3, 4, 7, 6, 12]
    @test sigma_one_list(7)  == [1, 3, 4, 7, 6, 12, 8]
    @test sigma_one_list(8)  == [1, 3, 4, 7, 6, 12, 8, 15]
    @test sigma_one_list(9)  == [1, 3, 4, 7, 6, 12, 8, 15, 13]
    @test sigma_one_list(10) == [1, 3, 4, 7, 6, 12, 8, 15, 13, 18]

    @test divisor_sum(1)  == 1
    @test divisor_sum(2)  == 3
    @test divisor_sum(3)  == 4
    @test divisor_sum(4)  == 7
    @test divisor_sum(5)  == 6
    @test divisor_sum(6)  == 12
    @test divisor_sum(7)  == 8
    @test divisor_sum(8)  == 15
    @test divisor_sum(9)  == 13
    @test divisor_sum(10) == 18

    @test sum_sigma_one_list(1)  == sum(num_positive_divisors(x) for x in 1:1)
    @test sum_sigma_one_list(2)  == sum(num_positive_divisors(x) for x in 1:2)
    @test sum_sigma_one_list(3)  == sum(num_positive_divisors(x) for x in 1:3)
    @test sum_sigma_one_list(4)  == sum(num_positive_divisors(x) for x in 1:4)
    @test sum_sigma_one_list(5)  == sum(num_positive_divisors(x) for x in 1:5)
    @test sum_sigma_one_list(6)  == sum(num_positive_divisors(x) for x in 1:6)
    @test sum_sigma_one_list(7)  == sum(num_positive_divisors(x) for x in 1:7)
    @test sum_sigma_one_list(8)  == sum(num_positive_divisors(x) for x in 1:8)
    @test sum_sigma_one_list(9)  == sum(num_positive_divisors(x) for x in 1:9)
    @test sum_sigma_one_list(10) == sum(num_positive_divisors(x) for x in 1:10)

    @test σ_2(1)  == 1
    @test σ_2(2)  == 5
    @test σ_2(3)  == 10
    @test σ_2(4)  == 21
    @test σ_2(5)  == 26
    @test σ_2(6)  == 50
    @test σ_2(7)  == 50
    @test σ_2(8)  == 85
    @test σ_2(9)  == 91
    @test σ_2(10) == 130

    @test num_positive_divisors_list(1)  == map(num_positive_divisors, 1:1)
    @test num_positive_divisors_list(2)  == map(num_positive_divisors, 1:2)
    @test num_positive_divisors_list(3)  == map(num_positive_divisors, 1:3)
    @test num_positive_divisors_list(4)  == map(num_positive_divisors, 1:4)
    @test num_positive_divisors_list(5)  == map(num_positive_divisors, 1:5)
    @test num_positive_divisors_list(6)  == map(num_positive_divisors, 1:6)
    @test num_positive_divisors_list(7)  == map(num_positive_divisors, 1:7)
    @test num_positive_divisors_list(8)  == map(num_positive_divisors, 1:8)
    @test num_positive_divisors_list(9)  == map(num_positive_divisors, 1:9)
    @test num_positive_divisors_list(10) == map(num_positive_divisors, 1:10)
end

@testset "Factorial.jl" begin
    @test lowest_k_such_that_n_divides_k_factorial(1) == 1
    @test lowest_k_such_that_n_divides_k_factorial(2) == 2
    @test lowest_k_such_that_n_divides_k_factorial(3) == 3
    @test lowest_k_such_that_n_divides_k_factorial(4) == 4
    @test lowest_k_such_that_n_divides_k_factorial(5) == 5
    @test lowest_k_such_that_n_divides_k_factorial(6) == 3
    @test lowest_k_such_that_n_divides_k_factorial(7) == 7
end

@testset "Mobius.jl" begin
    @test μ(1)  == 1
    @test μ(2)  == -1
    @test μ(3)  == -1
    @test μ(4)  == 0
    @test μ(5)  == -1
    @test μ(6)  == 1
    @test μ(8)  == 0
    @test μ(9)  == 0
    @test μ(10) == 1
    @test μ(12) == 0
    @test μ(15) == 1
    @test μ(18) == 0

    for i in 1:10
        @test μ_leq(i) == map(μ, 1:i)
    end

    @test count_squarefree_numbers_lt(1) == 0
    @test count_squarefree_numbers_lt(2) == 1
    @test count_squarefree_numbers_lt(3) == 2
    @test count_squarefree_numbers_lt(4) == 3
    @test count_squarefree_numbers_lt(5) == 3
    @test count_squarefree_numbers_lt(10) == 6
    @test count_squarefree_numbers_lt(17) == 11
    @test count_squarefree_numbers_lt(76) == 47

end

@testset "Addition.jl" begin
    # Grab random numbers and use to test accuracy.
	for i in 1:10
		ns = map(abs, rand(Int64, 2))
		@test add_lattice_alg(ns[1], ns[2]) == BigInt(ns[1]) + BigInt(ns[2])
	end
end

@testset "Fibonnaci.jl" begin
    for (i, f) in enumerate(fibonnaci(10))
        if i == 1
            @test f == 1
        elseif i == 2
            @test f == 1
        elseif i == 5
            @test f == 5
        elseif i == 10
            @test f == 55
        end
    end

    @test fib_matrix_multiplication(1) == 1
    @test fib_matrix_multiplication(2) == 1
    @test fib_matrix_multiplication(5) == 5
    @test fib_matrix_multiplication(10) == 55
end

@testset "PalindromicNumbers.jl" begin
    @test is_palindrome(1) == true
    @test is_palindrome(22) == true
    @test is_palindrome(121) == true
    @test is_palindrome(12321) == true
    @test is_palindrome(12345) == false
    @test is_palindrome(1221) == true
    @test is_palindrome(1331) == true
    @test is_palindrome(1001) == true
    @test is_palindrome(1234321) == true
    @test is_palindrome(1234567) == false

    @test palindromic_products_of_numbers_with_n_digits(1) == []
    @test maximum(palindromic_products_of_numbers_with_n_digits(2)) == 9009
    @test minimum(palindromic_products_of_numbers_with_n_digits(2)) == 121
    @test length(palindromic_products_of_numbers_with_n_digits(2)) == 73
end

@testset "LinearCongruences.jl" begin
    @test modular_inverse(3, 11) == 4
    @test modular_inverse(10, 17) == 12
    @test modular_inverse(7, 26) == 15
    @test modular_inverse(14, 15) == 14
    @test modular_inverse(9, 28) == 25
    @test modular_inverse(2, 5) == 3
    @test modular_inverse(8, 19) == 12
    @test modular_inverse(23, 100) == 87
    @test modular_inverse(29, 101) == 7

    @test array_modular_inverse([3, 10, 7], 11) == [4, 10, 8]
    @test array_modular_inverse([14, 9, 2], 17) == [11, 2, 9]
    @test array_modular_inverse([8, 23, 29], 19) == [12, 5, 2]
    @test array_modular_inverse([1, 5, 12], 13) == [1, 8, 12]
    @test array_modular_inverse([4, 9, 16], 25) == [19, 14, 11]
    @test array_modular_inverse([17, 25, 31], 37) == [24, 3, 6]
    @test array_modular_inverse([10, 22, 34], 29) == [3, 4, 6]
    @test array_modular_inverse([12, 18, 24], 29) == [17, 21, 23]
end

@testset "Combinatorics.jl" begin
    @test collect(iterate_combinations(3)) == [
        "001", "010", "011",
        "100", "101", "110", 
        "111", "000"
    ]

    @test collect(iterate_combinations(2)) == [
        "01", "10", "11", "00"
    ]

    @test C(5, 2) == 10
    @test C(6, 3) == 20
    @test C(10, 5) == 252
    @test C(8, 0) == 1
    @test C(8, 8) == 1
    @test C(15, 1) == 15
    @test C(20, 10) == 184756
    @test C(7, 4) == 35
    @test C(30, 15) == 155117520
    @test C(50, 25) == 126410606437752

    @test C_mod_prime_p(5, 2, 7) == 3
    @test C_mod_prime_p(6, 3, 17) == 3
    @test C_mod_prime_p(10, 5, 19) == 5
    @test C_mod_prime_p(8, 0, 17) == 1
    @test C_mod_prime_p(8, 8, 17) == 1
    @test C_mod_prime_p(15, 1, 17) == 15
    @test C_mod_prime_p(20, 10, 173) == 165
    @test C_mod_prime_p(7, 4, 23) == 12
    @test C_mod_prime_p(30, 15, 17) == 0
    @test C_mod_prime_p(50, 25, 1009) == 589
    # C(0, 0) = 1
    @test C_mod_prime_p(0, 0, 1733) == 1
    # C(n, k) = 0 for k < 0
    @test C_mod_prime_p(0, -3, 1733) == 0

    @test kummers_theorem(10, 3, 2) == 3
    @test kummers_theorem(3, 2, 2) == 0
    # TODO more tests
end

@testset "Misc.jl" begin
    @test digits_to_number([1,2,3]) == 123
    @test digits_to_number([1,2]) == 12
    @test digits_to_number([1,2,0,3]) == 1203
    @test digits_to_number([0,1,2,3]) == 123

    @test tetration(2, 2) == 4
    @test tetration(2, 3) == 16
    @test tetration(2, 4) == 65536
end

@testset "DSU_Size.jl" begin
    D = DSU_Size()
    make_set!(D, 10)
    make_set!(D, 5)
    make_set!(D, 2)
    union_set!(D, 2, 5)
    # @assert D == DSU_Size(
    #     Dict{Int64, Union{Nothing, Int64}}(5 => 2, 2 => 2, 10 => 10),
    #     Dict{Int64, Union{Nothing, Int64}}(5 => 1, 2 => 2, 10 => 1)
    # )
    @assert find_set(D, 5) == 2

    D2 = DSU_Size([1, 2, 3, 4, 5])
    D3 = DSU_Size(1:50)
    #@show D2
end

#=
    Continued Fractions Tests below
=#

@testset "Continued_Fractions.jl" begin

    @test length_repeating_cycle_unit_reciprocals(2) == 0
    @test length_repeating_cycle_unit_reciprocals(3) == 1
    @test length_repeating_cycle_unit_reciprocals(5) == 0
    @test length_repeating_cycle_unit_reciprocals(6) == 1
    @test length_repeating_cycle_unit_reciprocals(7) == 6
    @test length_repeating_cycle_unit_reciprocals(9) == 1
    @test length_repeating_cycle_unit_reciprocals(8) == 0
    @test length_repeating_cycle_unit_reciprocals(10) == 0
    @test length_repeating_cycle_unit_reciprocals(200) == 0
    @test length_repeating_cycle_unit_reciprocals(101) == 4
    @test length_repeating_cycle_unit_reciprocals(89) == 44
    @test length_repeating_cycle_unit_reciprocals(33) == 2
    @test length_repeating_cycle_unit_reciprocals(1001) == 6
    
    # Basic cases
    @test Rational(ContinuedFraction([1])) == 1//1
    @test Rational(ContinuedFraction([2])) == 2//1
    @test Float(ContinuedFraction([1])) == 1.0
    @test Float(ContinuedFraction([2])) == 2.0

    # Simple continued fractions
    @test Rational(ContinuedFraction([1, 2])) == 3//2  # 1 + 1/2
    @test Rational(ContinuedFraction([2, 3])) == 7//3  # 2 + 1/3
    @test Float(ContinuedFraction([1, 2])) == 3/2
    @test Float(ContinuedFraction([2, 3])) == 7/3
    #@test Float(ContinuedFraction([1,1,1,1,1,1,1,1,1,1,1])) == 

    # Longer continued fractions
    @test Rational(ContinuedFraction([1, 2, 3])) == 10//7 # 1 + 1/(2 + 1/3)
    @test Rational(ContinuedFraction([3, 2, 1])) == 10//3  # 3 + 1/(2 + 1/1)
    @test Float(ContinuedFraction([1, 2, 3])) == 10/7
    @test Float(ContinuedFraction([3, 2, 1])) == 10/3

    # Edge cases
    @test Rational(ContinuedFraction([0])) == 0//1     # Zero as the only term
    @test Float(ContinuedFraction([0])) == 0

    # Large numbers
    @test Rational(ContinuedFraction([1, 1000, 1])) == 1002//1001
    @test Float(ContinuedFraction([1, 1000, 1])) == 1002/1001

    # Approximation cases
    @test Rational(ContinuedFraction([1, 1, 1, 1, 1])) == 8//5  # A longer fraction approximation
    @test Float(ContinuedFraction([1, 1, 1, 1, 1])) == 8/5

    # some golden ratio tests
    @test round(Float(ContinuedFraction(ones(Int,40))),digits=6) == 1.618034
    @test round(Float(ContinuedFraction([0], [1])),digits=6) == 1.618034

    # TODO tests with orbits

    @test visualize(ContinuedFraction([1,2,3])) == "1 + 1/(2 + 1/(3))"
    @test visualize(ContinuedFraction([1,2,3,4])) == "1 + 1/(2 + 1/(3 + 1/(4)))"
    @test visualize(ContinuedFraction([1,2,3], [1,2])) == "1 + 1/(2 + 1/(3 + 1/(1 + 1/(2 + ... ))))"
    @test visualize(ContinuedFraction([12], [1])) == "12 + 1/(1 + ... )"
    @test visualize(ContinuedFraction([-1, 2, -3])) == "-1 + 1/(2 + 1/(-3))"

    @test ContinuedFraction(1//2) == ContinuedFraction([0, 2])
    @test ContinuedFraction(3//4) == ContinuedFraction([0, 1, 3])
    @test ContinuedFraction(7//3) == ContinuedFraction([2, 3])
    @test ContinuedFraction(10//7) == ContinuedFraction([1, 2, 3])

    # Test negative fractions
    @test ContinuedFraction(-1//2) == ContinuedFraction([0, -2])
    @test ContinuedFraction(-7//3) == ContinuedFraction([-2, -3])

    # Test edge cases
    @test ContinuedFraction(0//1) == ContinuedFraction([0])  # Zero case
    @test ContinuedFraction(1//1) == ContinuedFraction([1])  # Unity
    @test ContinuedFraction(-1//1) == ContinuedFraction([-1])

    # Test large numbers
    @test ContinuedFraction(355//113) == ContinuedFraction([3, 7, 16])  # π approximation
    @test ContinuedFraction(22//7) == ContinuedFraction([3, 7])  # Another π approximation

    # TODO constructors for Continued_Fractions
    # orbit of [0] throws exception

end