# list of primes 1 to n
#=  TODO
	1. Get atkin sieve going
	2. hk has an insane sieve posted in solutions to p187

	Okay we might be able to use bitset sieves too loko at divyekapoor's soltuoin
	to problem 10.
=#
using Printf

function main()	
	# 3203324994356
	@time @assert sum(prime_list_erat(10000000)) == 3203324994356
end

#=
	Generates p_n# which is the nth primorial (multiply first n primes)
	Rememeber:
	0# = 1# = 1
	p# = 2(3)(5)(7) ... p if p prime
	p# = 2(3)(5)(7) ... p_i if p NOT prime where p_i biggest prime s.t. p_i < p
=#
primorial(n::Int64) = reduce(*, prime_list_erat(n))
# function primorial(n::Int64)
# 	primes = prime_list_erat(n)
# 	result = 1
# 	for p in primes
# 		result *= p
# 	end
# 	return result
# end

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
	for i in 1:length(primes)
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
	# Boolean array, indicies are 2 -> n
	A = [true for i in 2:n]
	lim = Int(floor(n^(0.5)))
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

function prime_list_atkin_sieve(n::Int64)
	
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
