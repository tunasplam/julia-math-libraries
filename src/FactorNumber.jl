# everything regarding factoring numbers goes here (DUH)

function mobius(n)
	#=
	Mobius(n) tell us a few things:
	mu(n) = -1 if n square free and odd # of divisors
			0 if nonsquarefree
			1 if square free and even # of divisors.
	so |mu(n)| basically tells us if a number is squarefree.

	https://en.wikipedia.org/wiki/M%C3%B6bius_function
	For how this algorithm works see "Properties" heading.
	Allows us to determine mu(n) without having to factor it.

	Note figure out the "roots of unity" reference.
	=#

end

function prime_factors(n::Int)::Vector{Int}

	factors = []

	if n == 1
		return []
	end

	# if even, add that factor and keep dividing out 2's til we
	# can no longer.
	if n % 2 == 0
		push!(factors, 2)

		n ÷= 2
		while n % 2 == 0
			n ÷= 2
		end
	end

	# now starting at 3, check every odd number up to sqrt(n)
	factor = 3
	max_factor = floor(n^(0.5))
	for factor in 3:2:max_factor

		if n % factor == 0
			n ÷= factor
			push!(factors, factor)

			max_factor = floor(n^(0.5))
		end
		factor += 2
	end

	# if here then n has been reduced to last prime factor.
	# push and return it.
	return push!(factors, n)

end

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
