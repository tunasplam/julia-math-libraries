module JuliaMathLibraries

    greet() = return "Hello"

    export square_root_digits
    include("SquareRoots.jl")

    export terminates
    include("Fractions.jl")

    export gcd
    include("GCD.jl")

    export prime_factors, prime_factorization, radical, radical_list, divisors
    include("FactorNumber.jl")

    export primes_leq_erat, primes_leq, is_prime, primorial_list, primorial
    include("Primes.jl")

    export num_positive_divisors, sigma_one_list, divisor_sum,
    sigma_two, sum_sigma_one_list, num_positive_divisors_list    
    include("Divisors.jl")

    export factorial, lowest_k_such_that_n_divides_k_factorial
    include("Factorial.jl")

    export mobius_list, mobius
    include("Mobius.jl")

    export add_lattice_alg
    include("Addition.jl")

    export quadratic_formula
    include("Quadratics.jl")

    export fibonnaci
    include("Fibonnaci.jl")
end
