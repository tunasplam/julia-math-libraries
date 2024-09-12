#=
Anything that regards partitioning things goes into here.
=#

#=
    Partition function P

    Gives all the ways that integer n can be written as
    the sum of positive integers where the order of the
    addends is not considered significant.
=#

using OffsetArrays

function partition_function_p(n::Integer)::Vector{Int}
    #=
    OEIS A000041

    Returns the first n of the partition function P for n = 1, 2, ..

    Uses Euler's recurrence equation which is found as equation
    11 in the Mathworld link below.

    https://mathworld.wolfram.com/PartitionFunctionP.html
    =#

    # we use OffsetArray to allow us to index at 0 for this sequence
    # this shifts the index left 1
    P = OffsetArray(zeros(Int, n+1), -1)
    P[0:10] = [1, 1, 2, 3, 5, 7, 11, 15, 22, 30, 42]
    if n ≤ 10
        return P[1:n]
    end

    for k in 11:n
        s = 0
        for i in 1:k
            sign = i % 2 == 0 ? -1 : 1
            i1 = k - i*(3i-1)÷2
            i2 = k - i*(3i+1)÷2
            if i1 >= 0
                s += sign * P[i1]
            else
                break
            end
            if i2 >= 0
                s += sign * P[i2]
            end
        end
        P[k] = s
    end

    return P[1:n]
end
