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
