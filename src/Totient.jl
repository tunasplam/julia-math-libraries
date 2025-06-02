# ϕ(n) = count k < n s.t. k and n are relatively prime (gcd(n,k) == 1)

using Memoize

@memoize function totient(n::Integer)::Integer
#=
	counts number of positive integers k up to n
	s.t. k and n are relatively prime.
	phi(n) = pi(p|n) [ 1 - 1/p ]
	So we need the prime factors of n in order for this to work.
=#
	for p in prime_factors(n)
		n *= (1 - 1/p)
	end
	return floor(Int, n)
end

function totient_leq(n::Integer)::Vector{Int}
	#=
		See Tangent: Linear Sieving header:
		https://gbroxey.github.io/blog/2023/04/30/mult-sum-1.html#summing-generalized-divisor-functions

		performs in O(y log log y) time
	=#
	# generate a sequence of natural numbers from 1:n
	phi = [k for k in 1:n]
	
	# iterate through all primes from 2 to y and use them to contribute to the phi values of
	# their multiples. NOTE we do not need to generate a list of primes here bc, as we iterate
	# upwards, if p == phi[p] the no prior primes have affected this current value of phi[p].
	# this means that p is prime. VERY SLICK. This can be done for any function that operates
	# using prime factors such as this.
	for p in 2:n
		if phi[p] == p
			for k in 1:(n ÷ p)
				phi[p*k] = (phi[p*k] ÷ p) * (p-1)
			end
		end
	end
	return phi
end
