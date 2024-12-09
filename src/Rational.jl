#=
    ContinuedFraction requires a few extensions to Rational
=#

# this overload of Rational allows conversion to Rationals
function Rational(cf::ContinuedFraction)
    #=
        Original code below for historic reasons

        Same as irrational but we don't have to worry about the formatting.
        This should always spit out a nice solution.
        Returns num // den AS A FRACTION (Rational)

        Note that the first value of cf is the whole part.

        @assert length(cf) > 0

        num = 1; den = cf[end]
        for i in length(cf)-1:-1:1
            # Keep adding and flipping. If you don't know whats going on
            # then work it out on paper.
            num += cf[i]*den

            temp = num
            num = den
            den = temp
        end

        # flipped one too many times so unflip here
        return den // num
    =#
    !terminates(cf) && throw(ArgumentError(LazyString(
        "provided continued fraction must terminate in order to be converted to Rational.")
        )
    )

    # TODO im sure we could do this functionally somehow
    q = 1 // cf.head[end]
    for i in length(cf.head)-1:-1:1
        q = denominator(q) // (numerator(q) + cf.head[i] * denominator(q))
    end
    return reciprocal(q)
end

#=
    Here we have a nice function that is suprisingly not in the base language
=#
function reciprocal(q::Rational)::Rational
    # all Rational's with numerator 0 are equivalent to 0 // 1
    return q != 0 // 1 ?
        denominator(q) // numerator(q) :
        throw(ArgumentError(LazyString(
            "cannot take reciprocal of 0.")
        ))
end

function terminates(q::Rational)::Bool
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

    a, b = numerator(q), denominator(q)

	fraction_gcd = gcd(a, b)
	if b == fraction_gcd
		return true
	end

	b ÷= fraction_gcd

	# only concerned about the primes, not the powers.
	return all(x->x in [2,5], prime_factors(b))
end
