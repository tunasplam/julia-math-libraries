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

end