module JuliaMathLibraries

include("./fibonnaci.jl")
include("./sequence.jl")

export fibonnaci
export fibonnaci_mod_k

greet() = print("Hello World!")

end # module JuliaMathLibraries
