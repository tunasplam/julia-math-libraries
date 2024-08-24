using JuliaMathLibraries
using Test
const J = JuliaMathLibraries

@testset "JuliaMathLibraries.jl" begin
    @test J.greet()== "Hello"
end

# square roots
# @testset "SquareRoots.jl" begin
#     @test J.square_root_digits(2,11) == 1.41421356237
#     @test J.square_root_digits(3,11) == 1.73205080756
# end    

# Fractions
@testset "Fractions.jl" begin
    @test J.terminates(1, 5) == true
    @test J.terminates(2, 3) == false
    @test J.terminates(1, 7) == false
    @test J.terminates(10, 100) == true
    @test J.terminates(5, 7) == false
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

# FactorNumber
@testset "FactorNumber.jl" begin
    @test sort(prime_factors(6),  rev=true) == [3, 2]
    @test sort(prime_factors(10), rev=true) == [5, 2]
    @test sort(prime_factors(1),  rev=true) == []
    @test sort(prime_factors(15), rev=true) == [5, 3]
    @test sort(prime_factors(28), rev=true) == [7, 2]

    @test sort(prime_factorization(6),  by=x -> x[1], rev=true) == [(3, 1), (2, 1)]
    @test sort(prime_factorization(10), by=x -> x[1], rev=true) == [(5, 1), (2, 1)]
    @test sort(prime_factorization(1),  by=x -> x[1], rev=true) == []
    @test sort(prime_factorization(15), by=x -> x[1], rev=true) == [(5, 1), (3, 1)]
    @test sort(prime_factorization(28), by=x -> x[1], rev=true) == [(7, 1), (2, 2)]

    @test sort(divisors(6),  rev=true) == [6, 3, 2, 1]
    @test sort(divisors(10), rev=true) == [10, 5, 2, 1]
    @test sort(divisors(1),  rev=true) == [1]
    @test sort(divisors(15), rev=true) == [15, 5, 3, 1]
    @test sort(divisors(28), rev=true) == [28, 14, 7, 4, 2, 1]
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

    @test sigma_two(1)  == 1
    @test sigma_two(2)  == 5
    @test sigma_two(3)  == 10
    @test sigma_two(4)  == 21
    @test sigma_two(5)  == 26
    @test sigma_two(6)  == 50
    @test sigma_two(7)  == 50
    @test sigma_two(8)  == 85
    @test sigma_two(9)  == 91
    @test sigma_two(10) == 130

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
