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
# TODO if linear_sieve is faster then switch this over
primorial(n::Int64) = reduce(*, prime_list_linear_sieve(n))

#=
	Generates 1#, 2#, ... , p_n#
	Rememeber:
	0# = 1# = 1
	p# = 2(3)(5)(7) ... p if p prime
	p# = 2(3)(5)(7) ... p_i if p NOT prime where p_i biggest prime s.t. p_i < p
=#
function primorial_list(n::Int64)
	result = ones(n)
	primes = prime_list_erat(n)
	prim = 1
	for p in 2:n
		# if p prime then multiply it to our primorial.
		if p in primes
			prim *= p
			result[p] = prim
		# otherwise just use the result from before.
		else
			result[p] = result[p-1]
		end
	end
	return result
end

# TODO estimates of prime counting function to get it so we can make
# n close to the number of primes?
function primorial_list_no_repeats(n::Int64)
	primes = prime_list_erat(n)
	result = ones(length(primes))
	prim = 1
	for i in eachindex(primes)
		prim *= primes[i]
		result[i] = prim
	end
	return result
end

# determine whether or not a number is prime.
function prime(n::Int64)
	# NOTE remove this if you know n will never be 2 or 3 for
	# more performance
	if n == 2 || n == 3
		return true
	end

	if n % 2 == 0
		return false
	elseif n % 3 == 0
		return false
	else
		r = floor(n^(0.5))
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

# Faster if n > 10^6
function prime_list_erat(n::Int64)
	#=
		This runs in O(n log n)
	=#
	print("WARNING: prim_list_erat is SLOW and uses lots of RAM. use prime_list_linear_sieve instead.")
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

function prime_list_linear_sieve(n::Int64)
	#=
		This runs in O(n)
		See this blog post
		https://codeforces.com/blog/entry/54090

		The idea is very beautiful.
		Assume that all numbers are prime unless proved otherwise.
		Iterate through numbers from 2:n
		if the number is marked as prime, add it to primes.
		mark all multiples of the prime as composite

		Note that this likely requires much more RAM than prime_list_erat()
		ACTUALLY ... NO. This is ENORMOUSLY superior to the erat method
		IN EVERY WAY.
	=#
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

function main()
	lim = 10^7

	@time p2 = prime_list_erat(lim)
	@time p3 = prime_list_linear_sieve(lim)

	@printf "%s .. %s\n" p2[1:10] p2[length(p2)-10:length(p2)]
	@printf "%s .. %s\n" p3[1:10] p3[length(p3)-10:length(p3)]

	println(length(p2))
	println(length(p3))
	@assert length(p2) == length(p3)

	for i in eachindex(p2)
		if p2[i] != p3[i]
			@printf "%d %d != %d\n" i p2[i] p3[i]
		end
	end
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
