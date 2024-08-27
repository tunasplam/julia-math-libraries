# everything regarding factoring numbers goes here (DUH)

function prime_factors(n::Int)::Vector{Int}

	factors = []

	if n == 1
		return []
	end

	for p in primes_leq(n÷2)
		if n % p == 0
			n ÷= p
			push!(factors, p)
		end
	end
	# if here then n has been reduced to last prime factor.
	# push and return it.
	if n ∉ factors && is_prime(n)
		return push!(factors, n)
	end

	# if here then n has been reduced to the product of the
	# duplicate factors. discard it.
	return factors

end

# TODO i think this is wrong too
function prime_factorization(n::Int)::Vector{Tuple{Int,Int}}
	# get the twos first
	power, factorization = 0, []
	while n % 2 == 0
		power += 1
		n ÷= 2
	end
	if power > 0
		push!(factorization, (2, power))
	end

	limit = floor(Int, n^(0.5))
	for i in 3:2:limit
		power = 0
		while n % i == 0
			power += 1
			n ÷= i
		end
		if power > 0
			push!(factorization, (i, power))
		end
	end

	if n > 2
		push!(factorization, (n, 1))
	end
	return factorization
end

function radical(n::Int)::Int
#=
	The product of the distinct prime factors of n.
	note that squarefree integers are equal to their radical (pretty self evident)
	So if we can figure out mobius function that might help us here.

	multiplicative with rad(p^a) = p
=#
	p_fact = list_prime_divisors(n)
	rad = 1
	for p in p_fact
		rad *= p
	end
	return rad
end

function radical_list(n::Int)::Vector{Int}
	#=
	finds rad(n) for 1:n
	=#
	result = [radical(i) for i in 1:n]
	return result
end

function divisors(n::Int)::Vector{Int}
	divs = [1]

	if n == 1
		return divs
	end

	# check perfect square
	if isinteger(sqrt(n))
		append!(divs, Int(sqrt(n)))
		append!(divs, n)
		return divs
	end

	lim = floor(Int, sqrt(n))
	for i in 2:lim
		if n % i == 0
			append!(divs, i)
			append!(divs, n ÷ i)
		end
	end

	append!(divs, n)
	return divs
end
