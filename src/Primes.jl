# list of primes 1 to n
#=  TODO
	1. Get atkin sieve going

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

#=
Below we have miller rabin functions. Each function is optimized to used simplest set of witness
primes that guarantees deterministic results for inputted bit size.

	https://cp-algorithms.com/algebra/primality_tests.html#miller-rabin-primality-test

	TODO if x is Int128 but Int32 method is faster and it would fit, route to Int32 method?
	TODO if bigint, do we do probabilistic aproach? Tackle this one last.
=#

function binpower(b::Int, e::Integer, m::Integer)::Integer
	#=Returns b^e mod m. This uses binary exponentiation.
	=#
    result = 1
	# just in case b > m
    b %= m
	# while there are still factors of two in the power
    while e ≠ 0
		# if e is odd
        if e & 1 == 1
			# if we are here, then we have one final b to multiply
            result = result * b % m
		end
		# square the current value
		b = b * b % m
		# integer divide e by 2
        e >>= 1
	end
    return result
end

function check_composite(x::Integer, a::Integer, d::Integer, s::Integer)::Bool
	#= Given _, returns true if x is composite
	=#
	# y = a^d % x
	y = binpower(a, d, x)
	if y == 1 || y == x - 1
		return false
	end

	for _ in 1:s-1
		y = y * y % x
		if y == x - 1
			return false
		end
	end
	return true
end

function miller_rabin(x::Int64)::Bool
	#= Returns True if a given input is prime.
	=#
	@assert x > 0

	if x < 2 || x % 2 == 0
		return false
	end

	#=
	If an input x is odd (safe to assume at this point), then x - 1 is even
	and we can factor powers of 2 from it.
	Thus, we can say
		x - 1 = 2^s * d 	(d is odd)
	Below, we determine the values of d and s.
	=#
	s = 0
	d = x - 1
	# this checks if the least significant bit of d is 1. it is a parity check.
	while (d & 1) == 0
		d >>= 1
		s += 1
	end

	#=
	Using d and s, we can use fermat's little theorem on 
		a^(n-1) % n == 1 <-> a^(2s) - 1 % n == 0
					== ...
					== (a^(2^(s-1)d)+1) (a^(2^(s-2)d)+1) ... (a^d+1)(a^d-1) % n == 0

		The first statement implies that n is prime. The fact that it is equivalent to the
		final statment means that if n is prime, then n has to divide one of these factors.
		for a base 2 ≤ a ≤ n - 2, we check if
				a^d % n == 1
			or
				a^(d*2^r) % n == -1
		for some r ∈ [0, s-1]

		If we found a base a which does not satify any of the above equalities, then we have found
		a witness for the compositeness of n, meaning that n is not prime.

		TODO I have no idea what that means
	=#

	# checks each base that could be a possible witness for an integer in the provided range.
	for a in [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37]
		# duh
		if x == a
			return true
		end

		# check if a^d % x is composite
		if check_composite(x, a, d, s)
			return false
		end
	end
	return true
end
