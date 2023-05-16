
#=  Theorem 6-1 on page 104 of our number theory book
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

function sigma_zero_list_brute_force(num)
	#=
	I am sure there are nice identities to speed this up.
	Doesn't work i think things got renamed
	=#
	sigma = []
	for i in 1:num
		p_fact_powers = prime_factors(i)
		total = 1
		for power in p_fact_powers
			total *= (power + 1)
		end
		append!(sigma, p_fact_powers)
	end
	return sigma
end

function generate_sigma_zero_list(lim)
	#=
	Here are the nice identities to speed it up.
	note that there is apparently a recurrence relation but gonna
	try this for fun.

	Yeah. This doesn't work.
	=#
	primes = prime_list_erat(lim)
	sigma_zero = zeros(Int, lim)
	sigma_zero[1] = 1

	# Start by populating all primes as 2. Then knock out their powers.
	# for a prime p, sigma_zero(p^k) = 2^k
	for p in primes
		sigma_zero[p] = 2
		k = 2
		while p^k < lim
			sigma_zero[p^k] = k + 1
			k += 1
		end
	end

	# Now for all of the numbers that have not been generated.
	for n in 1:length(sigma_zero)

		# here check if n prime, if so do the algorithm for the primes
		# TODO faster to do this or run out prime test?
		# skip if already generated
		if sigma_zero[n] > 0 || n in primes
			continue
		end

		# find number of positive divisiors. doing it here so p_fact is saved
		# for later.
		p_fact = prime_factorize(n)

		tau = 1
		# Prime factorization is list of tuples (prime, power)
		for prime_pair in p_fact
			tau *= prime_pair[2] + 1
		end
		sigma_zero[n] = tau

		#= Now, generate the values for each prime being multiplied and the powers
		of those primes being multiplied. More speed can be added possibly by adding
		more cases here.
		for now covers...
		2*3 2*3^2 2*3^3 ...
		2*3*5 2*3*5^2 2*3*5^3 ...
		2*3*5*7 2*3*5*7^2 ...
		=#
		k = n
		# t # of distinct primes being used
		#t = 1
		for p in primes[1:end]
			# if this prime is in the p_fact of n, skip
			flag = false
			for q in p_fact
				if q[1] == p
					flag = true
					break
				end
			end
			if flag
				continue
			end

			if k*p > lim
				break
			end
			sigma_zero[k*p] = sigma_zero[k] * 2
			#l = k*p

			# # now the powers
			# l = k*(p^2)
			# while l < lim
			# 	if l == 988
			# 		println(n, " ", p)
			# 	end
			# 	sigma_zero[l] = sigma_zero[l ÷ p] + 2^t
			# 	l *= p
			# end
			# k *= p
			# t += 1
		end
	end
	return sigma_zero
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

function main()
	#=
	Things to look at for both n and sigma(n)
		- prime factors -> i don't see anything.
		- divisors -> doubt we will see a pattern here.
		- ratio between terms -> no don't see much here either.
		- sqrt
	=#

	squares = []
	for n in 1:10^5
		total = generate_sigma_two(n)
		if isinteger(sqrt(total))
			@printf "%d \t sigma_two = %d \t %d\n" n total sqrt(total)
			append!(squares, total)
		end
	end
	sort!(squares)
	unique!(squares)
	#println(squares)
	#for i in 1:length(squares)-1
	#	println(squares[i+1]/squares[i])
	#end
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end