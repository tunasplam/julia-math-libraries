# julia-math-libraries

Some math libraries that I made for usage while solving Project Euler problems
https://projecteuler.net/

Some of these algorithms are my original work. Some of them are from number theory text books or online math sources. Usually, if I snagged the algorithm from somewhere else then I left the source in the comments. This may not always be true though.

Please note that not everything has been thoroughly tested. For the most part, once the library accomplished what I needed it to do I left it until it was needed at another time.

Experimental stuff or stuff from before testing is in `legacy/`.

# Highlights

### DSU.jl
Disjoint Set Unions. Very cool data structure thats very efficient for things like finding the minimum value of all subsequences in a sequence.

### ContinuedFraction.jl
Continued Fractions are insane. They are quite difficult to think about and work with. The functions in here makes them much more approachable. `Float.jl` also includes and extension of `Float` that allows for the conversion of a `ContinuedFraction` to `Float`. Similar for `Rational` can be found in `Rational.jl`.

### Mobius.jl
Several implementations of algorithms related to the mobius function.

### Rational.jl
Mentioned above already, but there are some other neat little functions in there.

### legacy/pell_equations.jl
Old and not looked at in quite a while. But still very fun. These were implementations of Pell Equation solvers that I used in a couple of Project Euler problems. 

# Test
julia REPL:
```
] activate .
test
```

# Build / Install Locally
julia REPL:
```
] dev .
```

# Benchmark
Below is an example of using `BenchmarkTools` to compare two functions `prime_factors(x::Int)` and `prime_factors_2(x::Int)`. Notice that the setup provides a list of random Integers (`BenchmarkTools` intelligently picks the amount of samples to generate).

julia REPL:
```
using BenchmarkTools
using JuliaMathLibraries
const J = JuliaMathLibraries

@benchmark J.prime_factors setup=(x=rand(Int, 10^5))
@benchmark J.prime_factors_2 setupp=(x=rand(Int, 10^5))
```

## Algorithms Covered (in no way is this list updated)

### addition_algorithms.jl
- Lattice Addition (for large numbers)

### algebra.jl
- Quadratic Formula
- Determinate of Quadratic Equations
- Simplest Radical Form
- Inverse of Simplest Radical Form

### constructing_numbers_from_divisors.jl
- What is the smallest number divisiblae by EACH of the numbers 1 .. k ?

### continued_fractions.jl
- Converting a continued fraction to a rational number
- Converting a continued fractoin to an irrational number (not thoroughly tested)
- Converting numbers to continued fractions
- Checking if a given partially computed continued fraction has an orbit
- Finding the kth convergent square root of n
- A bunch of functions to explore what happens if we 'iterate' through continued fractions

### divisors.jl
- The number of positive divisors of n (tau function)
- Various algorithms for generating the sum of the divisors of n
- Various algorithms for generating the sum of the squares of the divisors of n

### factorial.jl
- A generator for n!
- A generator for n! % k
- Finding the last k digits of n!
- Finding the last k digits before the trailing zeros in n! (this one was particularly fun to solve)
- Find the lowest integer k such that n divides k! (TODO not sure if this one was 100% working)

### factor_number.jl
- Listing the factors an integer
- Prime factorization of an integer
- List of the prime factors of an integer (without noting their powers)
- Finding the product of the distinct prime factors of n

### fibonnaci.jl
- Generator for the fibonnaci sequence
- Generator for the fibonnaci sequence % k
- Generator for the tribonnaci sequence (add the last 3 numbers rather than the last 2)
- Generator for the tribonnaci sequence % k
- OEIS A001175 Periods of the fibonnaci sequence % n

### fractions.jl
- Checks if a fraction represents a terminating or repeating decimal

### gcd.jl
- Crappy generic brute force algorithm for gcd(a,b)
- Finding the bezout coefficients for a and b
- Extended Euclidean Algorithm for finding gcd(a,b)
- A recursive algorithm for solving gcd(a,b) that uses some identities which is not particularly fast but might be optimized for certain situations. I am not quite sure but it was interesting to implement.

### last_digits.jl
- Finding the last n digits of a^b

### linear_congruences.jl
*** I remember this library giving me fits. There are DEFINITELY problems in here
- Chinese Remainder Theorem (CRT) optimized for two equations with coefficient of x being 1
- Finding the modular inverse of a mod n
- Taking a linear congruence with a coefficient of x and simplifying it to have no coefficient
- Also a failed attempt at a generalized CRT algorithm

### misc_sequences.jl
- Generator for triangular numbers
- Generator for pentagonal numbers
- List out all hamming (5-smooth) numbers up to n
- Lots of differnet hamming number algorithms

### partitions.jl
*** There are some functions here that may be misplaced and should be somewhere else
- Number of partitions of n (OEIS A000041) 
- Number of partitions of n with size k
- Number of partitions of n with distinct values (OEIS A000009)
- Number of partitions of n with size k with distinct values
- Number of sequences of positive integers (repetition allowed) who sum to n (OEIS A011782)
- A recurrence relation to generate binomial numbers
- Generating the partitions of n lexicographically
- Several binomial number identities
- Generating the partitions of n split by values in a set S

### pascals_triangle.jl
- Generator first n rows of pascal's triangle
- Generator for first n rows of pascal's  triangle mod k

### pell_equations.jl
- Solving pell equations
- Solving general pell equations

### polynomials.jl
- Multiplying polynomials
- Nice print formatting for polynomials
- Lagrange method of polynomial interpolation
- Solving polynomials

### primes_list.jl
- Finding the nth primorial
- Checking if n prime
- Sieve of erasthenes

### pythagorean.jl
- Generating the primitive triples

### sequence.jl
- Splitting a sequence into k distinct subsets
- Checking if a sequence has a cycle
- Finding the subsequences of a sequence

### squarefree.jl
- Checking if a number is square free (mobius function)

### totient.jl
- Find the totient formula (phi(k)) for 1 ... n
- Totient of a number

