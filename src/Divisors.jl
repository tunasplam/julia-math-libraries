#= 
Theorem 6-1 on page 104 of our number theory book
  has a beautiful algorithm that we can use

 Going to test it against our other divisor algorithm to 
 check for speed.

TODO: Sum of divisors in problem 23 solutions. Look at alvaro's code
suposedly theres a nice explanation somewhere on mathschallenge.net as well.
https://mathschallenge.net/index.php?section=faq&ref=number/sum_of_divisors
see p153.jl for implementation

=#



#=
	TODO Make this a function:
	For a number n, count how many times some prime p will be a prime factor of all
	numbers <= n.
	Call it C(n, p)

	So C(39, 3) = 18 since 3 appears 18 times when writing out the prime
	factorizations of all numbers <= 39.

	Here is the algorithm:

	C(n,p)
	x, count = 0, 0
	m = floor( log_p n )
	for i in 1:m
		count += i * (floor( n / p^i) - x)
		x = floor( n / p^i )

	turns into the nice summation equation:
	C(n, p) = sum_{1}^{floor(log_p n)} = i * ( floor(n/p^i) - floor(n^{p^i+1}) )

=#

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

function proper_divisors(n::Int)::Vector{Int}

	if n == 1
		return []
	end

	divs = [1]

	# check perfect square
	if isinteger(sqrt(n))
		append!(divs, Int(sqrt(n)))
		return divs
	end

	lim = floor(Int, sqrt(n))
	for i in 2:lim
		if n % i == 0
			append!(divs, i)
			append!(divs, n ÷ i)
		end
	end

	return divs
end

function num_positive_divisors(num::Int)::Int
	#=
	FORMERLY CALLED generate_sigma and generate_sigma_zero
	Counts the number of positive divisiors of num.

	A couple of things that could speed this up:
	- This is multiplicative if gcd(n, m) = 1
	- tau(p^k) = k + 1 for p prime.

	Algorithm:
	n = p1^r1 * p2^r2 *... * pk^rk
	tau(n) = (r1 + 1)(r2 + 1) ... (rk + 1)
	=#
	p_fact = prime_factorization(num)

	tau = 1
	# Prime factorization is list of tuples (prime, power)
	for prime_pair in p_fact
		@inbounds @fastmath tau *= prime_pair[2] + 1
	end
	return tau
end

function divisor_sum(n::Int)::Int
	#=
	Returns the sum of the divisors of the input

	https://mathworld.wolfram.com/DivisorFunction.html
	See equation 14 in the above link.
	=#
	total = 1
	for factor in prime_factorization(n)
		@inbounds @fastmath total *= (factor[1]^(factor[2] + 1) - 1)÷(factor[1] - 1)
	end
	return total
end

function sigma_one_list(n::Int)::Vector{Int}
	#=
	Gives us the SUM of the divisors for each of the first n integers.

	Called 'sigma_one' because this sequence is the result of the
	divisor function for k = 1

	OEIS A000203
	=#
	return map(divisor_sum, 1:n)
end

function sigma_two(n::Int)::Int
	#=
	Determine the sum of the squares of the divisors of an integer.
	=#
	return reduce(+, map(x -> x^2, divisors(n)))
end

function sum_sigma_one_list(x::Int)::Int
	#=
		Sum of the # of divisors of n for n ≤ x

		Uses the Dirichlet Hyperbola method. O(sqrt(x)) time.
		https://gbroxey.github.io/blog/2023/04/30/mult-sum-1.html

		2 * sum_{n ≤ x} floor(x/n) - floor(x)^2

		The math on how to arrive to this is very fun and insightful but
		requires some pictures so please refer to the link. There are definitely
		many more series that we can apply this method to.
	=#
	s = isqrt(x)
	r = 0
	@inbounds for n in 1:s
	@fastmath	r += x ÷ n
	end
	@fastmath return 2r - s^2
end

function min_num_divisible_by_primes_leq_k(k::Int)::BigInt
	#=
	You could just find LCM of all primes leq k.
	but this works efficiently for large inputs
	=#
	N, i = 1, 1
	check = true
	limit = floor(Int, sqrt(k))
	primes = primes_leq(k)
	for prime in primes
		prime_power = 1
		if check
			if primes[i] <= limit
				prime_power = floor(Int, log10(k) / log10(prime) )
			else
				check = false
			end
		end
		N = N * prime ^ prime_power
	end
	return N
end

function num_positive_divisors_list(x::Int)::Vector{Int}
	#=
		See the header "Tangent: Linear Sieving"

		https://gbroxey.github.io/blog/2023/04/30/mult-sum-1.html#summing-generalized-divisor-functions

		Runs in O(xlogx)
		This returns a sequence where each value is the number of divisors of the index number.

		OEIS: A000005
	=#
	d = zeros(x)

	for k in 1:x
		# increment d[k*j] for all multiples k*j <= x
		@inbounds @fastmath for j in 1:(x ÷ k)
			@inbounds @fastmath d[k*j] += 1
		end
	end
	return d
end

function kth_divisor_function_sum(x::Int, k::Int, m::Int)::Int
	#=
		See "Algorithm (Computing D_k(x) iteratively)
		https://gbroxey.github.io/blog/2023/04/30/mult-sum-1.html#summing-generalized-divisor-functions

		Runs n O(x/sqrt(y)) where y is the size of the sieved values.
		The speed of this comes from sieving the first y values and then
		iteratively knocking out the rest of the vlaues using the hyperbola method.

		If y is picked on the order of x^(2/3), then the runtime is O(kx^(2/3))

		The returned value is:
		d_k(1) + d_k(2) + ... + d_k(x) mod m

		The result is the sum of the kth power of the number of divisors for each natural number.

		OEIS for k = 4: A001159

		TODO a version without mod to save time? does that matter?
		TODO implement linear_sieve_prod_unit

		TODO THIS DOES NOT WORK!
	=#
	print("WARNING. THIS DOES NOT WORK.")

	# 1. set y on the order of x^(2/3)
	y = Int(floor(0.55*x^(2/3)))
	y = max(y, isqrt(x))

	# this is the sequence that will be used for the sieve. Length y
	sieved = [i % m for i in 1:y]

	# this is the array that will be updated using the hyperbola method. Length x/y
	# initiliaze all elements to (x ÷ y) % m
	big = [(x ÷ y) % m for i in 1:(x ÷ y)]

	# iterate through each value of k
	for j in 2:k
		# update big first. iterate through every element
		# this is done using the hyperbola method. The formula is too atrocious to write
		# in the comments here so make sure to follow the link in the function documentation.
		for i in eachindex(big)
			v = x ÷ i
			vsqrt = isqrt(v)
			bigNew = 0
			for n in 1:vsqrt
				# add D_{j-1}(v/n) = D_{j-1}(x/(i*n)) (first summation in hyperbola method)
				# hit the sieve if we can
				if v ÷ n <= y
					bigNew += sieved[v ÷ n]
				else
					bigNew += big[i*n]
				end
				# add d_{j-1}(n) floor(v/n) (second summation in hyperbola method)
				bigNew += (sieved[n] - sieved[n-1]) * (v ÷ n)
				bigNew = bigNew % m
			end
			# subtract the overlap (third bit of the hyperbola method)
			bigNew -= sieve[vsqrt]*vsqrt
			big[i] = bigNew % m
		end
		# update sieved using sieving
		# convert sieved from summation to d_{j-1}, convolve, then convert back
		for i in y:-1:1
			sieved -= sieved[i-1]
		end
		# TODO implement this :)
		sieved = linear_sieve_prod_unit(small, m)
		for i in eachindex(small)
			sieved[i] = (sieved[i] + sieved[i-1]) % m
		end
	end

	# fill up the return array by combining sieved and big
	Dk = Array{Int64}(undef, x)
	for i in eachindex(Dk)
		if i <= y
			Dk[i] = sieved[i]
		else
			Dk[i] = big[x ÷ y]
		end
	end
	return Dk
end
