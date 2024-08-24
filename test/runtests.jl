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
