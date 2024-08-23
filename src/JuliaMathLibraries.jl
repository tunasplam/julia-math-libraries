module JuliaMathLibraries

greet() = return "Hello"

export square_root_digits
include("SquareRoots.jl")

export terminates
include("Fractions.jl")

end