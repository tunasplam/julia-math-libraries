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

    @show index, 2^C.n

    # represent index as bitstring and grab the rightmost n digits
    # yield the new value and the new index
    return bitstring(index)[end-(C.n-1):end], index + 1

end
Base.length(C::Iterate_Combinations) = 2^C.n
