#=
    Continued fractions are cool. We represent them with vectors as such:

    [1 2 3 4] = 1 + 1/(2+1/3+(1/4))

    a fun visualization function is the first function you can use here for fun.
=#

function visualize_cf(cf::Vector{Int})::String
    # This is one of the coolest things I have ever discovered.
    return " + 1/(".join(cf) + ")" * (length(cf) - 1)
end

function cf_to_rational(cf::Vector{Int})::Rational
	#=
	Same as irrational but we don't have to worry about the formatting.
	This should always spit out a nice solution.
	Returns num // den AS A FRACTION (Rational)

	Note that the first value of cf is the whole part.
	=#

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
end

function continued_fraction_to_irrational_number(cf; whole_part::Integer=0)
	#=
	Takes a continued fraction representing an irrational
	number and converts it to an irrational number.
	Remember, all irrational numbers have periodic continued fractions.

	There are two parts.. the first part is collapsing the cf.

	We have x = 1/(c[1] + 1/(cf[2] + 1/(cf[3] + x))
	for a cf with an orbit of 3.

	Once that is collapsed, it will give us
	x = (a1 + b1x)/(a2 + b2x)

	Which yeilds...
	b2x^2 + (a2 - b1)x - a1 = 0

	That can be solved using quadratic formula.
	We are only interested in the plus part of the answer.

	TODO
	HAS NOT BEEN TESTED THOROUGHLY.

	=#
	# numerator constant and coefficient of x
	a1 = 1; b1 = 0
	# denominator constant and coefficient of x
	a2 = cf[end]; b2 = 1
	for i in length(cf)-1:-1:1
		a1 = cf[i]*a2 + a1; b1 = cf[i]*b2 + b1
		
		# flip the fraction over by swapping
		temp = a1
		a1 = a2
		a2 = temp
		temp = b1
		b1 = b2
		b2 = temp
	end

	# set up and solve our quadratic equation.
	result = quadratic_formula(b2, a2-b1, -a1, formatted=true, sol_type="plus")

	# Whole part, add it to the result. So result[1] will increase
	# by whole_part*result[2]
	if whole_part > 0
		result[1] = whole_part*result[2]
	end
	return result
end
