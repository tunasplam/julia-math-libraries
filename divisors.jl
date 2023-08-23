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

include("./factor_number.jl")
include("./primes.jl")
using Printf

function number_positive_divisors(num)
	#=
	FORMERLY CALLED generate_sigma and generate_sigma_zero
	Counts the number of positive divisiors of num.

	A couple of things that could spped this up:
	- This is multiplicative if gcd(n, m) = 1
	- tau(p^k) = k + 1 for p prime.

	Algorithm:
	n = p1^r1 * p2^r2 *... * pk^rk
	tau(n) = (r1 + 1)(r2 + 1) ... (rk + 1)
	=#
	p_fact = prime_factorize(num)

	tau = 1
	# Prime factorization is list of tuples (prime, power)
	for prime_pair in p_fact
		tau *= prime_pair[2] + 1
	end
	#println(tau)
	return tau
end

function generate_sigma_one(n)
	#=
	Gives us the SUM of the divisors.
	https://mathworld.wolfram.com/DivisorFunction.html
	See equation 14 in the above link.
	=#
	sigma = []
	for i in 1:n
		p_fact = prime_factors(i)
		total = 1
		for factor in p_fact
			total *= (factor[1]^(factor[2] + 1) - 1)÷(factor[1] - 1)
		end
		append!(sigma, total)
	end
	return sigma
end

function generate_sigma_two(n::Integer)
	# find the divisors, then square them and sum them.
	divisors = [1, n]
	for i in 2:sqrt(n)-1
		if n % i == 0
			append!(divisors, i)
			append!(divisors, n/i)
		end
	end
	# check if perfect square
	if n % sqrt(n) == 0
		append!(divisors, sqrt(n))
	end

	total = 0
	for div in divisors
		total += div^2
	end
	return total
end

function divisor_sum_dirichlet_hyperbola(x)
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
	for n in 1:s
		r += x ÷ n
	end
	return 2r - s^2
end

function num_positive_divisors_linear_sieve(x::Int64)
	#=
		See the header "Tangent: Linear Sieving"

		https://gbroxey.github.io/blog/2023/04/30/mult-sum-1.html#summing-generalized-divisor-functions

		Runs in O(xlogx)
		This returns a sequence where each value is the number of divisors of the index number.

		OEIS: A000005
	=#
	d = Array{Int64}(undef, x)

	for k in 1:x
		# increment d[k*j] for all multiples k*j <= x
		for j in 1:(x ÷ k)
			d[k*j] += 1
		end
	end
	return d
end

function kth_divisor_function_sum(x::Int64, k::Int64, m::Int64)
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
	=#
	# 1. set y on the order of x^(2/3)
	y = Int64(floor(0.55*x^(2/3)))
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

function main()
	test_set = sum([
		1, 17, 82, 273, 626, 1394, 2402, 4369, 6643, 10642, 14642, 22386, 28562,
		40834, 51332, 69905, 83522, 112931, 130322, 170898, 196964, 248914, 279842, 358258,
		391251, 485554, 538084, 655746, 707282, 872644, 923522, 1118481, 1200644
	])

	@time res = kth_divisor_function_sum(3, 43, 10000000)

	println(test_set)
	println(res)

end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end