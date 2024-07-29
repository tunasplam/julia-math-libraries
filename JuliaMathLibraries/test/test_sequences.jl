using JuliaMathLibraries
using Test

@testset "check_sequence_for_cycle" begin
    @test check_sequence_for_cycle([1,1,1]) == [1]
    @test check_sequence_for_cycle([1,2,1,2]) == [1,2]
    @test check_sequence_for_cycle([1,2,1,2,1]) == [1,2]
    @test check_sequence_for_cycle([1,2,3,4,1,2,3,4]) == [1,2,3,4]
    @test check_sequence_for_cycle([1,2,3,4,1,2,3,4,1]) == [1,2,3,4]
    @test check_sequence_for_cycle([1,2,3,4,1,2,3,4,1,2]) == [1,2,3,4]
    @test check_sequence_for_cycle([1,2,3,4,1,2,3,4,1,2,3]) == [1,2,3,4]
    @test check_sequence_for_cycle([1,2,1,2,3,1,2,1,2,3,1,2]) == [1,2,1,2,3]
    @test check_sequence_for_cycle([1,2,1,2,3,1,2,1,2,3,1,2,1,2,3]) == [1,2,1,2,3]
    @test check_sequence_for_cycle([1,3,2,4]) == []
end