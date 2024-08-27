# list of primes 1 to n
#=  TODO
	1. Get atkin sieve going
	2. hk has an insane sieve posted in solutions to p187

	Okay we might be able to use bitset sieves too loko at divyekapoor's soltuoin
	to problem 10.
=#
using Printf


#=
	Generates p_n# which is the nth primorial (multiply first n primes)
	Rememeber:
	0# = 1# = 1
	p# = 2(3)(5)(7) ... p if p prime
	p# = 2(3)(5)(7) ... p_i if p NOT prime where p_i biggest prime s.t. p_i < p
=#
# TODO
# TODO if linear_sieve is faster then switch this over
# yeah this doesnt work. at all.
# primorial(n::Int)::Int = reduce(*, primes_leq(n))


function primorial_list(n::Int)::Vector{Int}
	#=
	Returns a list of all primorials <= n

	The idea of this algorithm is to generate the first 50
	primorials and filter the list to return all values <= n.
	=#

	# Generate a list of primes up to this value
	primes = primes_leq(50)
	# build up primorials for all of the primes
	result = ones(length(primes))
	prim = 1
	for i in eachindex(primes)
		prim *= primes[i]
		result[i] = prim
	end
	return filter(x -> x <= n, result)
end

# determine whether or not a number is prime.
function is_prime(n::Int64)::Bool
	# NOTE remove this if you know n will never be 2 or 3 for
	# more performance
	if n == 1
		return false
	end

	if n == 2 || n == 3
		return true
	end

	if n % 2 == 0
		return false
	elseif n % 3 == 0
		return false
	else
		r = floor(Int, n^(0.5))
		f = 5
		while f <= r
			if n % f == 0
				return false
			end
			if n % (f + 2) == 0
				return false
			end
			f += 6
		end
		return true
	end
end

function primes_leq_erat(n::Int)::Vector{Int}
	#=
		This runs in O(n log n)
		
		DO NOT USE THIS. USE primes_leq INSTEAD.
	=#
	# Boolean array, indicies are 2 -> n
	A = [true for i in 2:n]
	lim = isqrt(n)
	# lim < n by definition so @inbounds is safe
	for i in 2:lim
		@inbounds if A[i-1]
			k = 0
			@fastmath j = i^2 + k*i
			while j <= n
				@inbounds A[j-1] = false
				@fastmath k += 1
				@fastmath j = i^2 + k*i
			end
		end
	end
	# Convert from bool array to primes list.
	# use this beautiful findall function
	A = findall(i -> A[i] == 1, [i for i in 1:length(A)])
	A = map(i -> i + 1, A)
	return A
end

function primes_leq(n::Int64)::Vector{Int}
	#=
		This runs in O(n)
		See this blog post
		https://codeforces.com/blog/entry/54090

		The idea is very beautiful.
		Assume that all numbers are prime unless proved otherwise.
		Iterate through numbers from 2:n
		if the number is marked as prime, add it to primes.
		mark all multiples of the prime as composite
	=#

	if n == 2
		return [2]
	end

	is_composite = [false for i in 2:n]
	primes = Vector{Int64}(undef, 0)
	for i in 2:(n-1)
		@inbounds if !is_composite[i]
			append!(primes, i)
		end

		# this loop only runs once per composite number so this performs at O(n) complexity.
		for j in 1:length(primes)
			# break if this value exceeds n
			@inbounds if i * primes[j] ≥ n
				break
			end

			# mark all multiples of this prime as composite
			@inbounds is_composite[i * primes[j]] = true

			# this guarantees that we pick out each composite only once.
			@inbounds if i % primes[j] == 0
				break
			end
		end
	end
	return primes
end
