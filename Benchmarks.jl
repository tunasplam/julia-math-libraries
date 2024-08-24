#=
    To redeploy code locally.
    In Julia REPL:

    using Pkg
    Pkg.add(path="/home/jordan/Project_Euler/julia-math-libraries")

    Note that you have to run these in REPL for this to work
=#

using BenchmarkTools
using JuliaMathLibraries

# add_lattice_alg ======================================

function addition_1(k)
    xs = map(abs, rand(Int, k))
    ys = map(abs, rand(Int, k))
    for (x, y) in zip(xs, ys)
        add_lattice_alg(x, y)
    end
end

@benchmark addition_1(100)

# regular addition ======================================

function addition_2(k)
    xs = map(abs, rand(Int, k))
    ys = map(abs, rand(Int, k))
    for (x, y) in zip(xs, ys)
        x + y
    end
end

@benchmark addition_2(100)
