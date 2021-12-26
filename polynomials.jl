#=
	Polynomials.
	Plop all things polynomials here.

=#

using Printf

function mulitply_polynomials(p1, p2, verbose::Bool=false)
	#=
		P1 = [ a1, a2, ... , ak]
		P2 = [ b1, b2, ... , bj]
		Make sure k > j and that all terms with coefficients of
		0 are included.
	
		order of terms:
		a1*x^k+1 + a2*x^k + ... + ak

		Find the size of the new polynomial.
		will be (length(P1)-1) + (length(P2)-1) + 1
		(D(P1) + D(P2))
		
		Need j temp arrays of the size calculated above.
		So make a matrix [j, D(p1)+D(p2)]

		For each ith entry in P2:
			multiply each element in P1 and shift the index left i-1 times.
			plop these all in the ith row of the matrix.

		Then add the columns of the matrix to get the answer.
	=#
	# TODO dunno why but "verbose" can't be found ???
	#=
	if verbose
		p1_string = format_string_polynomial(p1)
		p2_string = format_string_polynomial(p2)
		@printf "%s x %s = \n" p1_string p2_sting
	end
	=#
	if length(p1) < length(p2)
		temp = p2
		p2 = p1
		p1 = temp
	end

	results = zeros(Int, length(p2), (length(p1)-1)+length(p2))

	for i in 1:length(p2), j in 1:length(p1)
		results[i, j+i-1] = p2[i] * p1[j]
	end

	# Need to manually drop the extra dimensions when summing crap.
	result = dropdims(sum(results, dims=1), dims=1)
	#=
	if verbose
		r_string = format_string_polynomial(result)
		println(r_string)
	end
	=#
	return result
end

function format_string_polynomial(p1)
	#=
		Start from the highest degree on the left side of the list.
		returns the polynomial in a nice human accessible string.
	=#
	p1_string = ""
	for i in 1:length(p1)-1
		# Converting to string before printing bc can't figure out fractions with
		# printf.
		if p1[i] > 0
			p1_string = p1_string * "$(@sprintf("+%sx^%d ", string(p1[i]), length(p1)-i))"
		else
			p1_string = p1_string * "$(@sprintf("%sx^%d ", string(p1[i]), length(p1)-i))"
		end
	end
	if p1[length(p1)] > 0
		p1_string = p1_string * " +" * string(p1[length(p1)])
	else
		p1_string = p1_string * string(p1[length(p1)])
	end
	return p1_string
end

function interpolate_sequence_lagrange(sequence)
	#=
	Uses the Lagrange method of Interpolating Polynomials
	https://mathworld.wolfram.com/LagrangeInterpolatingPolynomial.html

	Uses a crap ton of polynomial multiplication.

	So basically, nested for loops.

	Note that this uses points (x1, y1), (x2, y2), ... , (xn, yn)
	To get around this for sequences, set x1, x2, ... , xn
	to be 1, 2, ... , n and leave the y's as the values of the
	sequence

	# TODO adopt this to work for 2D also, not just sequences.
	=#
	# Constant case
	if length(sequence) == 1
		return [1]
	end

	# sigma part
	n = length(sequence)
	result = zeros(Int, n)
	# Since its so weird and i am so tired do the j = 1 case first
	# then loop for the rest
	# does the k = 2 on the outside of the for loop and the rest on
	# the bottom.
	numerator_polynomial = [1, -2]
	denom = 1 - 2
	for k in 3:n
		numerator_polynomial = mulitply_polynomials(numerator_polynomial,
													[1, -1 *k])
		denom *= 1 - k
	end
	numerator_polynomial *= sequence[1]
	numerator_polynomial //= denom
	result += numerator_polynomial

	for j in 2:n
		# this is y_j
		product = sequence[j]
		# pi part
		# TODO I KNOW THERE HAS TO BE A NICE FORMULA TO SKIP this
		# CRAP BELOW.
		# create initial polynomial for the top part.
		numerator_polynomial = [1, -1]
		denom = j - 1

		for k in 2:n
			if k == j
				continue
			end
			# Here goes the crazy part.
			# for the numerator there is a crap ton of polynomial multiplication
			numerator_polynomial = mulitply_polynomials(numerator_polynomial,
														[1, -1 *k])
			denom *= j - k
		end
		numerator_polynomial *= product
		# This should produce all integer coefficients at the end of the day
		# so its okay to use the fractions.
		numerator_polynomial //= denom
		result += numerator_polynomial
	end
	# kill the rational numbers they should all be clean integers at this points
	#result = map(x -> convert(Int, x), result)
	return result
end

function solve_polynomial(p, x)
	#=
	Okie dokie artichokies
	See mulitiply_polynomials for how the format is.
	=#
	y, power = 0, length(p) - 1
	for value in p
		y += value*x^power
		power -= 1
	end
	return y
end
