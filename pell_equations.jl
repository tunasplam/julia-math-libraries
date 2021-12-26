# If it has to do with pell equation, plop it here.

#=	Idea:
	O Check the answer thread for problem 66 if you need more speed.
	There is an interesting algorithm there where one does not even need
	to calculate the numerators/denominators of the continued fraction,
	they just calculate the length of the sequence.

	TODO this stuff uses stuff from continued_fractions.jl
	import it you fool
=#

using Printf

function solve_pell_equation(D, num_solutions)
	#=
	Per wikipedia article on pell equations:

	"If a is the period of the continued fraction and c_k = p_k/q_k is the
	kth convergent, all solutions to the Pell equation are in the form
	(p_ia, q_ia) for all i in the positive integers."

	What does that mean? Well, first we need to find the period of the
	continued fraction. In the example below, the period of sqrt(3) is
	2,1 (note that in this case the period is NOT referring to the length
	of the pattern, but rather to the pattern ITSELF).

	The convergents are the portions of the infinite extended fraction that
	are truncated after every period.

	For example, for sqrt(3) = [1; 1, 2,1, 2,1, ... ]

	To generate the convergents:
	keep calculating
	[1; 1, 2,1]				=> 7/4    = p_1   /	q_1
	[1; 1, 2,1, 2,1]		=> 26/15  = p_1*2 / q_1*2
	[1; 1, 2,1, 2,1, 2,1]	=> 97/56  = p_2*2 / q_2*2
	& etc.

	So, we will need a function that generates the convergent fraction to
	a desireable limit and then this function will parse the periods.

	TODO look at 1st solution for D = 2. Theres an issue where it says
	1 // 1 is the solution but this is not the right answer.
	TODO check for square values of D.

	Returns list of fractions where each fraction is 
	=#
	#@printf "Finding first %d solutions to c^2 - %dd^2 = 1\n" num_solutions D
	#@printf "k \t p_k \t q_k\n"
	solutions = []
	k = 1
	while length(solutions) < num_solutions
		# I think the issue with the bad first solution lies in the
		# find_kth_convergent_sqrt function.
		fraction = find_kth_convergent_sqrt(D, k)
		# TODO figure this out some values of D have the first result
		# not correct this might be sucking out computation time.
		if numerator(fraction)^2 - D*denominator(fraction)^2 == 1
			append!(solutions, fraction)
			#@printf "%d \t %d \t %d\n" k numerator(fraction) denominator(fraction)
		end
		k += 1
	end
	return solutions
end

function solve_general_pell_equation(D, N, num_solutions)
	#=
	For context see problem 138
	I will never sleep. This can be made into a general pell equation.

	See the "Generalized Pell's equation" heading below.
	https://en.wikipedia.org/wiki/Pell%27s_equation#The_smallest_solution_of_Pell_equations
	
	Idea behind creating the pell equation:

	Pythagorean theorem creates this situation:

	(b/2)^2 + (b +- 1)^2 = L^2

	Solving for L gives a situation where we are interested in when
	5/4*b^2 + 2b + 1 is an integer (when it equals d^2 for some int d).

	Complete the square to make this new equation into the form

	(5b + 4)^2 - 20d^2 = -4
	which can be rewritten as
	c^2 - 20d^2 = -4 for some int c, a general pell equation of the form
	x^2 - dy^2 = N

	Note that
	e^2 - 20f^2 = 1 is the corresponding pell resolvant.

	There exists the multiplicative principle, namely:
	if (c_0, d_0) is a solution to c^2 - 20d^2 = -4 (the seed?)
	and (e_0, f_0) is a solution to e^2 - 20f^2 = 1 (its seed)
	then (c_n, d_n) is a solution to c^2 - 20d^2 = -4 where
	c_n + d_n*sqrt(20) = (c_0+d_0*sqrt(20))*(e_n+f_n*sqrt(20))

	This might rely on the fact that |N| < sqrt(20)
	i.e. |-4| < sqrt(20)

	So what do we do?
	- Find a seed solution to the general equation (use a graph I guess)
	- Find a seed solution to the resolvant.
	- Iterate through the resolvant using the convergents of sqrt of 20
	  and use them to generate solutions to resolvant.
	- Use solution from the resolvant and seed to general equation to find
	  the corresponding solution to the general equation.

	But first, confirm that our continued fraction methods will work for
	square root of 20

	This is a GREAT oppirtunity to modulize all our topical files.

	So found the continued fraction for sqrt(20) to be [4; 2, 8]
	with 2, 8 being the orbit.

	The first convergent of sqrt(20) is 9/2 meaning
	e_0 = 9 and f_0 = 2 is our seed solution of the resolvant.

	Going to do basic brute force to find seed solution of our general
	pell equation.
	Got c_0 = 4, d_0 = 1. Is this a degenerate triangle?

	Relate back to the original problem to find out.
	c = 5b +- 4 means b = (c - 4)/5
	c = 4 makes b = 0 so YES degenerate.

	=#
	# Find the solutions we need from the resolvant.
	resolvant_solutions = solve_pell_equation(D, num_solutions)

	@printf "Finding first %d solutions to c^2 - %dd^2 = %d\n" num_solutions D N
	@printf "n \t c_n \t d_n\n"

	# Find e_0 and f_0
	convergent = find_kth_convergent_sqrt(D, 1)
	e_0, f_0 = numerator(convergent), denominator(convergent)

	# Brute force find c_0 d_0
	c_0, d_0 = 0, 0
	for c in 1:100, d in 1:100
		if c^2 - D*d^2 == -4
			c_0, d_0 = c, d
			break
		end
	end

	# Check to make sure seed was found
	if c_0 == 0 && d_0 == 0
		println("Issue finding c_0 and d_0.")
		println("Brute forcing to find the seed didn't work.")
		return
	end

	@printf "0 \t %d \t %d\n" c_0 d_0

	# TODO number of solutions seem off? Check if you need to count
	# the seed solution.
	solutions = [[c_0, d_0]]
	for resolvant_solution in resolvant_solutions
		# renaming to make the equations below more readable
		e_n, f_n = numerator(resolvant_solution), denominator(resolvant_solution)

		c_n = c_0*e_n + d_0*f_n*D
		d_n = c_0*f_n + d_0*e_n

		append!(solutions, [[c_n, d_n]])
		@printf "%d \t %d \t %d\n" length(solutions)-1 c_n d_n
	end
	return solutions
end

function convergents_approach_old(c_1, d_1)
	#= 
		UPDATE THAT PREDATES ALL THAT IS BELOW.
		THIS MIGHT BE EXTRANEOUS NOW THAT WE HAVE FIGURED OUT HOW THE
		CONVERGENTS OF CONTINUED FRACTIONS WORK TO SOLVE PELL EQUATIONS.
		See convergents_approach()

		If this gets replaced, going to keep it because there are still
		some interesting concepts here that may be used (finding tons
		of future solutions of a Pell Equation using a few seed solutions.)
	=#


	# So the sequence from c_1 = 7 d_ 1 = 4 gives the z - 1 case
	# What about the z + 1 case?
	# TODO if something goes wrong check to make sure we are acutally
	# generating integer areas and not overflowing.
	# If so, throw in some bigs.

	# First find c_2 and d_2
	c_k_minus_1 = c_1^2 + 3*d_1^2
	d_k_minus_1 = 2*c_1*d_1

	# Find x, y, and z for these now.
	# Gonna have to revamp solving for z.
	if (c_k_minus_1 + 2) % 3 == 0
		z = 2*(c_k_minus_1 + 2) ÷ 3
		x = z - 1
		y = x 
	elseif (c_k_minus_1 - 2) % 3 == 0
		z = 2*(c_k_minus_1 - 2) ÷ 3
		x = z + 1
		y = x
	else
		println("Something F'd up.")
		exit()
	end

	@printf "k \t c_k \t d_k \t z \t x=y\n"
	@printf "%d \t %d \t %d \t ? \t ?\n" 1 c_1 d_1 
	@printf "%d \t %d \t %d \t %d \t %d\n" 2 c_k_minus_1 d_k_minus_1 z x

	k = 3
	total = 0
	while x + y + z < 10^9
		c_k = c_k_minus_1 * c_1 + 3 * d_k_minus_1 * d_1
		d_k = c_k_minus_1*d_1 + c_1 * d_k_minus_1

		if (c_k + 2) % 3 == 0
			z = 2*(c_k + 2) ÷ 3
			x = z - 1
			y = x 
		elseif (c_k - 2) % 3 == 0
			z = 2*(c_k - 2) ÷ 3
			x = z + 1
			y = x
		else
			println("Something F'd up.")
			exit()
		end

		@printf "%d \t %d \t %d \t %d \t %d\n" k c_k d_k z x

		c_k_minus_1 = c_k
		d_k_minus_1 = d_k
		total += x + y + z
		k += 1
	end
	println(total)
	return total
end

function find_kth_convergent_sqrt(n, k)
	#=

	Find the kth convergent of the square root of n.
	1. Find the continued fraction.
	2. Repeat the orbit (presumably cf[2:] but verify...) k times.
	3. Convert this new cf to a regular fraction.

	=#

	cf = expand_square_root(n)
	new_cf = [cf[1]]
	for i in 1:k append!(new_cf, cf[2:length(cf)]) end
	new_cf = map(x -> floor(Int, x), new_cf)
	new_cf = new_cf[1:length(new_cf)-1]

	a = pop!(new_cf)
	while length(new_cf) > 0
		b = pop!(new_cf)
		a = b + 1//a
	end
	return a
end

function expand_square_root(n)
	#=
	Hi. Later jordan here. Conjugate??? You mean Reciprocal??
	Also here was my verbatim documentation from it:

	Uses a super cryptic algorithm that I pieced together on a bus...
	Finds the period of the continued fraction of a square root.
	Returns the continued fraction.

	Well, past Jordan, to be exact this is returning the
	continued fraction truncated after the first orbit.

	TODO clean this up with julia's fraction operations.
	=#

	if isinteger(sqrt(n))
		return [sqrt(n)]
	end

	cf = []
	# 1. Initial step
	m = floor(sqrt(n))
	# append first integer part to cf
	append!(cf, m)
	# 2. append second values
	append!(cf, floor((sqrt(n)+m) / (n - m^2)))
	c = m
	conjugate = n - m^2
	# check bail condition
	if conjugate == 1 
		return cf
	end

	# Keep going until we bail.
	while true
		# 3. find new c
		c = c - cf[length(cf)] * conjugate
		# c should always be negative at this point
		# 4. Append new value to cf
		append!(cf, floor(conjugate/(sqrt(n)+c)))

		# 5. Get new fraction via conjugate
		# This should always be an integer
		conjugate = (n-abs(c)^2)/conjugate
		
		if conjugate == 1
			return cf
		end
		m = abs(c)
		c = abs(c)
	end

end
