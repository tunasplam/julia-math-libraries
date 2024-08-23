# Factor a number into prime factors.

#=
	Bunch a crap here from before I started being more anal about
	organizing these files.

	Since then adding:
	- Square free numbers (using mobius function)
=#

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

function factor(n)

	factors = []

	# check if even so then we can iterate by 2's laster on.
	# if even, add that factor and keep dividing out 2's til we
	# can no longer.
	# NOTE> since everything should divide cleanly, using integer
	# division massively improves precision.
	if n % 2 == 0
		push!(factors, 2.0)
		n ÷= 2
		while n % 2 == 0
			n ÷= 2
		end
	end

	# now starting at 3, check every odd number up to sqrt(n)
	factor = 3
	max_factor = floor(n^(0.5))
	while n > 1 && factor <= max_factor
		if n % factor == 0
			n ÷= factor
			push!(factors, factor)
			while n % factor == 0
				n ÷= factor
			end

			max_factor = floor(n^(0.5))
		end
		factor += 2
	end
	if n == 1
		return factors
	# if here then n has been reduced to last prime factor.
	# push and return it.
	else
		println(typeof(n))
		return push!(factors, n)
	end

end

# TODO TODO TODO there is a problem ehre look at p179.jl
# Think i fixed it though...
# This fellow returns list of tuples (num, power)
# NOTE > returninga nicely formatted string representation is considerably
# faster than returning an array of tuples. Test to see if unpacking that
# string representation is still faster than using the array
function prime_factorize(n)

	factorization = []

	# check if even so then we can iterate by 2's laster on.
	# if even, add that factor and keep dividing out 2's til we
	# can no longer.
	# NOTE> since everything should divide cleanly, using integer
	# division massively improves precision.
	power = 1
	if n % 2 == 0
		n ÷= 2
		while n % 2 == 0
			n ÷= 2
			power += 1
		end
		push!(factorization, (2, power))
	end

	# now starting at 3, check every odd number up to sqrt(n)
	factor = 3
	max_factor = floor(n^(0.5))
	while n > 1 && factor <= max_factor
		power = 1
		if n % factor == 0
			n ÷= factor
			while n % factor == 0
				n ÷= factor
				power += 1
			end
			push!(factorization, (factor, power))
			max_factor = floor(n^(0.5))
		end
		factor += 2
	end
	if n == 1
		return factorization
	# if here then n has been reduced to last prime factor.
	# push and return it.
	else
		push!(factorization, (n, 1))
		return factorization
	end

end

function list_prime_divisors(n)
#= 
	Prime factorization method altered to ignore the powers.
	So just returns the primes p. Useful for totient function.
=#
	factorization = []
	if n % 2 == 0
		while n % 2 == 0
			n ÷= 2
		end
		push!(factorization, 2)
	end

	# now starting at 3, check every odd number up to sqrt(n)
	factor = 3
	max_factor = floor(n^(0.5))
	while n > 1 && factor <= max_factor
		if n % factor == 0
			n ÷= factor
			while n % factor == 0
				n ÷= factor
			end
			push!(factorization, factor)
			max_factor = floor(n^(0.5))
		end
		factor += 2
	end
	if n == 1
		return factorization
	# if here then n has been reduced to last prime factor.
	# push and return it.
	else
		push!(factorization, n)
		#println("Heyy")
		return factorization
	end

end

function prime_factors(n)
	# get the twos first
	power, factorization = 0, []
	while n % 2 == 0
		power += 1
		n ÷= 2
	end
	if power > 0
		push!(factorization, (2, power))
	end

	limit = Int(floor(n^(0.5)))
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

function radical(n)
#=
	The product of the distinct prime factors of n.
	note that squarefree itnegeres are equal to their radical (pretty self evident)
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

function radical_list(n)
	#=
	finds rad(n) for 1:n
	=#
	result = [radical(i) for i in 1:n]
	return result
end

function divisors(n)
	divs = [1]
	lim = floor(Int, sqrt(n))
	for i in 2:lim
		if n % i == 0
			append!(divs, i)
			append!(divs, n ÷ i)
		end
	end

	# check perfect square
	if isinteger(sqrt(n))
		append!(divs, Int(sqrt(n)))
	end
	append!(divs, n)
	return divs
end

# function main()
# 	lim = 10^5
# 	@time test = [ [radical(i), i] for i in 1:lim]
# 	unique!(test)
# 	sort!(test)
# 	println(test[4][2])
# 	println(test[6][2])
# 	println(test[10000][2])
# end

# main()