function Float(cf::ContinuedFraction)
	#=
    Converts a cf to a float.

    Okay, this was something we apperenly only glanced the surface of
    all those years ago. This is actually something very cool.

    Consider a cf with orbit 2 [c1 c2 ;].

    Thus, x = 1/(c1 + 1/(c2 + x))
    Which equates to c1 x^2 + (c1c2 - 1)x + 1 - c2 = 0
    which is a quadratic equation.

    If fact, all of these setup quadratic equations to be solved.
    The problem is, the quadratic equations get nastier and nastier as the
    orbits increase.

    So that is not a feasible solution. (its a recurrence relation)
    So what we do instead is cheese it in a very unelegant manner

    head = [1 2 3 4]; orbit = [3 7]

    -----
    Here is the original documentation kept for nostalgiac purposes:

	Takes a continued fraction representing an irrational
	number and converts it to an irrational number.
	Remember, all irrational numbers have periodic continued fractions.

	There are two parts.. the first part is collapsing the cf.

	We have x = 1/(c[1] + 1/(cf[2] + 1/(cf[3] + x))
	for a cf with an orbit of 3.

	Once that is collapsed, it will give us
	x = (a1 + b1x)/(a2 + b2x)

	Which yields...
	b2x^2 + (a2 - b1)x - a1 = 0

	That can be solved using quadratic formula.
	We are only interested in the plus part of the answer.
	=#

	# just evaluate the first 100 terms (all of them if theres less than 100)
	# TODO I am pretty sure these cases will always end up at 100 terms but its
	# also not the end of the whole if they dont so im not stressing about that
	# right now
	
	PRECISION = 100

	# trivial case: 0
	if cf == ContinuedFraction([0])
		return 0.0

	# trivial case: integer
	elseif length(cf.head) == 1 && terminates(cf)
		return cf.head[1]
	end

	# head not enough and no orbit. just evaluate
	if length(cf.head) < PRECISION && terminates(cf)
		terms = cf.head

	# head more than 100 terms, just use them
	elseif length(cf.head) >= PRECISION
		terms = cf.head[1:PRECISION]

	elseif length(cf.head) < PRECISION && length(cf.orbit) > 0

		# case of head not enough, theres an orbit, but more
		# terms than we need in one cycle.
		# NOTE To be honest, this case will never fire.
		if length(cf.orbit) > PRECISION - length(cf.head)
			terms = vcat(cf.head, cf.orbit[1:(PRECISION-length(cf.head))])

		# need to repeat orbit to fill in the rest of the terms
		else
			# number of times we need to repeat the orbit
			d = (PRECISION - length(cf.head)) ÷ length(cf.orbit)
			terms = vcat(
				cf.head,
				cf.orbit * d + cf.orbit[1:PRECISION-(length(cf.head)+length(cf.orbit))]
			)
		end
	end

	# divide out the fractional terms
	result = terms[end]^-1
	for x in reverse(terms[2:end-1])
		result += x
		result ^= -1
	end
	# add the whole part and return
	return result + terms[1]
end
