#=
	Miscellaneous fractions stuff.
=#

include("./factor_number.jl")
include("./gcd.jl")

function terminates(a, b)
	#=
	Returns true if terminating and false if repeating.
	Cool little algorithm i figure out..

	For fraction a / b :
	terminating if the prime factorization of
	b / gcd(a, b) contains only 2's and 5's.
	I bet the proof has something to do with the fact that these are
	decimal digits and 2 and 5 are the prime factors of 10. mod 10
	is probably involved.

	so 770/175 terminates bc p.fact is (11*7*5*2)/(7*5*5)
	which reduces down to (11*2)/5 and denominator only contains a 5.
	
	The only exception would be if b divides a. Then its a whole number
	and therefore terminating.
	=#

	fraction_gcd = gcd(a, b)
	if b == fraction_gcd
		return true
	end

	b ÷= fraction_gcd

	# only concerned about the primes, not the powers.
	p_fact = list_prime_divisors(b)
	return all(x->x in [2,5], p_fact)

end
