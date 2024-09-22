function C(n::Integer, k::Integer)::Integer
    #=
        Calculate nCr without any modular arithmetic.
        https://cp-algorithms.com/combinatorics/binomial-coefficients.html#improved-implementation

        NOTE if you need to use lots of small Combinations
        it would probably be better to precompute and cache
        the factorial values. Then the calculations of each nCr
        will be O(1)

        NOTE if you need lots of small Combinations it could also
        be better to stash these in a lookup table generated using
        Pascal's Theorem (basically, generate the triangle).
    =#
    res = 1
    for i in 1:k
        res = res * (n - k + i) / i
    end
    return round(Int, res)
end


function C_mod_m(n::Integer, k::Integer, m::Integer)::Integer
    #=
        Calculate nCr % m.
        Use this:
        https://cp-algorithms.com/combinatorics/binomial-coefficients.html#binomial-coefficient-modulo-an-arbitrary-number

        Requires CRT implementation.
        TODO we have not used this yet because for now all we need
        is C_mod_prime.
    =#  
end

function C_mod_prime_p(n::Integer, k::Integer, p::Integer)::Integer
    #=
        Calculate nCr % p where p is prime.
        https://cp-algorithms.com/combinatorics/binomial-coefficients.html#binomial-coefficient-modulo-large-prime
    
        NOTE if you are going to use this multiple times then you want to cache the
        values of factorial_mod_m up to the maximum input value n.
        
        So you should implement this function custom everytime you use it. Refer
        to an array `factorial` that is primed at the beginning with:

        factorial[1] = 1
        for i in 1:max_n
            factorial[i] = factorial[i-1] * i % p
        end

        NOTE if you need factorial[0] then use those cool offset arrays.
    =#
end

function C_mod_prime_power_p(n::Integer, k::Integer, p::Integer)::Integer
    #=
        Calculate nCr % p where p is a prime power.
        https://cp-algorithms.com/combinatorics/binomial-coefficients.html#mod-prime-pow

        TODO not implementing yet but keeping this here as a reminder.
    =#  
end

mutable struct Iterate_Combinations
    #=
    Iterate through all of the ways you can choose k indicies from
    n elements for k = 0:n. Represented as a bitstring of length n with k 1's
    and (n-k) 0's.

    iterate through these
        ..00000
        ..00001
        ..00010
        ..00101
        ...
    
        The idea is to iterate through 1:2^n and return
        each binary representation as a string.

        the sole argument is n which is the amount of digits to consider.
    =#

    n::Integer

end

# this starts off the iterator by instantiating the struct with 
# index 1 and n digits to consider
function iterate_combinations(n::Integer)
    return Iterate_Combinations(n)
end

# we always start iterating from 1, that is why index=1
function Base.iterate(C::Iterate_Combinations, index=1)
    # checks for the stop condition
    # we want index ≤ 2^n
    if index > 2^C.n
        return nothing
    end

    # represent index as bitstring and grab the rightmost n digits
    # yield the new value and the new index
    return bitstring(index)[end-(C.n-1):end], index + 1

end
Base.length(C::Iterate_Combinations) = 2^C.n
