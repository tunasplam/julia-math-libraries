using JuliaMathLibraries
using Test

@testset "fibonnaci" begin
    @test collect(fibonnaci(10)) == [1,1,2,3,5,8,13,21,34,55]
    @test collect(fibonnaci(5)) == [1,1,2,3,5]
    @test collect(fibonnaci(1)) == [1]
    @test collect(fibonnaci(2)) == [1,1]
    @test fibonnaci(5)[5] == 5
end

@testset "fibonnaci_mod_k" begin
    @test fibonnaci_mod_k(5, 3)[5] == 2
    @test fibonnaci_mod_k(10,7)[10] == 6
    @test collect(fibonnaci_mod_k(5, 3)) == [1,1,2,0,2]
end
