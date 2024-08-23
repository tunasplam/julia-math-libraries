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

