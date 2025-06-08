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

function partition_function_p_list(n::Int)::Vector{Int}
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

function num_partitions_n_into_prime_parts_list(N::Int)::Vector{Int}
    #=
    OEIS A000607

    See equations 5 through 8 in the mathworld link below.
    We are Euler transforming the sequence a_n (the prime indicator function)
    to b_n (our target sequence).

    essentially, we are using equation 8

    https://mathworld.wolfram.com/EulerTransform.html
    =#

    # NOTE have done benchmarks in benchmarks/is_Prime.jl that suggest
    # using J.is_prime for checking prime is pretty fast.

    # stash all values of sequence b_n here
    B = zeros(Int, N)
    B[1:10] = [0, 1, 1, 1, 2, 2, 3, 3, 4, 5]
    if N ≤ 10
        return B[1:N]
    end    
    # NOTE that c_n is essentially the sum of the prime factors of k
    c(n) = sum(prime_factors(n))

    for n in 1:N
        # tried to mirror it as closely to the mathworld formula as possible
        @fastmath @inbounds B[n] = (c(n) + sum([c(k)*B[n-k] for k in 1:n-1])) ÷ n
    end
    return B
end

function partitions(n::Int)::Vector{Vector{Int}}
#= 
    https://www.quora.com/Algorithm-to-split-a-number-into-different-ordered-group-such-that-sum-of-those-numbers-make-original-number
	originally was thinking a recursive way. And there is a recursive way on that link
	but it is not very clear. Brute force solution.
    They resutls are in lexicographic order
=#	
    # current parition being processed
	case = []
	cases = []
	# First case is n 1's
    case = ones(Int, n)

	while true
		# Keep adding on 1's sum is n
		while sum(case) != n
			push!(case, 1)
		end

		push!(cases, copy(case))

        # remove last number from list and inrease second-to-last by 1.
		# (merge the last two values)
		pop!(case)
		if length(case) == 0
			return cases
		end
		case[end] += 1
	end
	return cases
end