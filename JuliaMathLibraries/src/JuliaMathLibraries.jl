module JuliaMathLibraries

include("./fibonnaci.jl")
export fibonnaci
export fibonnaci_mod_k

include("./sequence.jl")
export check_sequence_for_cycle

greet() = print("Hello World!")

end # module JuliaMathLibraries
