include("./gcd.jl")
#include("./primes_list.jl")
using Printf

function main()
	lim = 10^7
	@time l1 = [totient(x) for x in 1:lim]
	@time l2 = totient_list(lim)
	println(l1[1:30])
	println(l2[1:30])

	for i in 1:lim
		if l1[i] != l2[i]
			@printf "%d %d != %d\n" i l1[i] l2[i]
		end
	end
end

function totient_list(n)
#=
	Generate phi(n) for 1 .. n using some nifty properties:
	For m, b < n
		phi(mb) = phi(m)phi(b)*d/phi(d) where d = gcd(m,b)
			Note that when gcd(m,b) = 1 then phi(mb) = phi(m)phi(b)
			This is multiplicative property

		phi(2m) = 2phi(m) if m is even
		phi(2m) = phi(m) if m is odd

		# looks like this makes us slightly slower.
		phi(b^m) = b^(m-1)phi(b)

		BTW significantly slower to check if a is prime and set phi(a) as a - 1

		TODO TRY THIS:
		generate list of primes.
		Cycle through each prime p and use p - 1 and the tricks above.
		Then restart from the beginning and bruteforce/use tricks on what wasn't
		generated.

	So basically assign everything as 0. Run though and bruteforce
	everytime a 0 is encountered. Then figure out as many other easy values
	as we can using the properties above.
=#
	result = zeros(Int, n)
	result[1] = 1
	for a in 2:n
		# skip is already generated
		if result[a] != 0
			continue
		end

		# brute force phi(a)
		result[a] = totient(a)

		# multiplicative first.
		# TODO at some point in the process this might end up being more work
		# bc most of the values will have been generated. Find that point.
		lim_b = floor(Int, n/a)
		for b in 3:lim_b
			prod = a*b
			if result[prod] != 0
				continue
			end
			d = gcd(a, b)
			result[prod] = round(Int, result[a] * result[b] * (d/result[d]))
		end

		# Now the multiples of 2
		# If a is odd.. start off by doing the odd case then doing the even
		# case as much as possible
		if a % 2 == 1 && a*2 < n
			result[a*2] = result[a]
			ta = a*2
			while ta*2 < n
				result[ta*2] = 2*result[ta]
				ta *= 2
			end
		end
		# For the even case just do even case as much as possible
		if a % 2 == 0 && a*2 < n
			ta = a
			while ta*2 < n
				result[ta*2] = 2*result[ta]
				ta *= 2
			end
		end

	end
	return result
end

function totient(n)
#=
	phi(n) = pi(p|n) [ 1 - 1/p ]
	So we need the prime factors of n in order for this to work.
	BTW what is this? counts number of positive integers k up to n
	s.t. k and n are relatively prime.
=#
	prime_factors = list_prime_divisors(n)
	for prime in prime_factors
		n *= (1 - 1/prime)
	end
	return floor(Int, n)
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

main()