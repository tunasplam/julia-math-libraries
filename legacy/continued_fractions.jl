# TODO Several functions below could be updated to use Julia's fraction
# type.

include("./sequence.jl")
include("./algebra.jl")
using Printf

function continued_fraction_to_rational_number(cf)
	#=
	Same as irrational but we don't have to worry about the formatting.
	This should always spit out a nice solution.
	Returns num // den AS A FRACTION.

	Note that the first value is the whole part.
	=#
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

# Below all converted from python script for continued fractions written
# on bus ride to disney land
function convert_to_continued_fraction(num::Integer, den::Integer)
	# Nice version that plays well with integers.
	# TODO julia has stuff to handle fractions.
	a, b = num, den
	cf = []
	while b != 0
		# compute quotient and remainder
		a = Int(num÷den)
		b = num % den
		# Append next part to continued fraction.
		append!(cf, a)
		# Shift over values for next iteration
		num = den
		den = b
	end
	return cf
end

function convert_to_continued_fraction(num, den)
	#=
		Okay... going to have to worry about when we have nasty
		irrational inputs. We get a loss of percision after like 15
		terms. This should be okay though because once we have the
		repeating pattern, then we know that we are good to go.

		Can return None if no cycle found.
	=#
	a, b = num, den
	cf = []
	while b != 0
		# compute quotient and remainder
		a = Int(num÷den)
		b = num % den
		# Append next part to continued fraction.
		append!(cf, a)
		# Shift over values for next iteration
		num = den
		den = b

	end
	# check the first 10 or so terms for a cycle.
	# Starting at 2nd term bc 1st is the whole part of the approximation.
	cycle = check_orbit(cf)
	return cycle
end

function check_orbit(cf)
	#=
	Check an input cf for whether we have an orbit (repeating cycle)
	Some things to take into account:
	1. There can be more than one digit floating around at the star that
	is not a part of the cycle.
	2. Around the 15th term of our converter, our cf will be inaccurate.
	=#

	# slowly grow the amount of digits at the beginning of cf that we ignore.
	# also slowly grow the endpoint (so that we don't have to deal with
	# the imprecision of our continued fraction maker.)
	for ignored_digits in 1:length(cf)-1, end_point in 5:length(cf)
		cycle =	check_sequence_for_cycle(cf[ignored_digits + 1:end_point])
		# NOTICE the === here. This is the faster way to check if something
		# is nothing.
		if cycle !== nothing
			return cycle
		end
	end
end

function find_kth_convergent_sqrt(n, k)
	#=
	TODO ONLY DID THIS FOR SQRT(3) IF GOING TO USE FOR ANY OTHER
	SQUARE ROOT VERIFY THAT THIS WORKS.

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

	TODO Need to identify the period somehow.
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

#=
	Iterates through the continued fractions form big -> small
	n is the amount of digits to be in the continued fraction.
	
	TODO FIGURE OUT THE WHOLE PART!!
	For now, integer part will always be 0.
	Could add an integer part arg here though very easily

	if you want small -> big i think you can iterate backwards bc
	of the fact that we implemented indicies. Not sure though.

	Btw.. we need the 0's... pretty sure we can just switch all
	the 9's to 10's and zeros.
	But yeah do that tomorrow.

	0's mess up the order of everything. very messy.
	For zeros just iterate with for loop.
	In fact lets do time comparisions.
=#
mutable struct CF_Iterator
	# number of digits.
	n::Int
	# previous cf
	last_cf::Array{Int64,1}
	# Whole part defaults to zero
	#whole_part::Int
end

# Yeah get a load of that start condition. whew.
cf_iterator(n::Integer) = CF_Iterator(n, reverse!(
		digits(
			n % 2 == 0 ? parse(Int, "19"^floor(Int, n/2)) : parse(Int, "19"^floor(Int, n/2)*"1")
		)))
cf_iterator(n::Integer, whole_part::Integer) = CF_Iterator(n, reverse!(
		digits(
			n % 2 == 0 ? parse(Int, "19"^floor(Int, n/2)) : parse(Int, "19"^floor(Int, n/2)*"1")
		)))

Base.length(CFI::CF_Iterator) = CFI.n
Base.firstindex(CFI::CF_Iterator) = 1
Base.lastindex(CFI::CF_Iterator) = length(CFI)
Base.getindex(CFI::CF_Iterator, i::Number) = CFI[convert(Int, i)]
Base.getindex(CFI::CF_Iterator, I) = [CFI[i] for i in I]

function Base.iterate(CFI::CF_Iterator, state=1)
	# Because of the issues with 9^k % 1 on i = 1,
	# yield the initial value that is gnerated in the constructor.
	if state == 1
		#if CFI::whole_part > 0
		#	return (pushfirst(CFI.last_cf, CFI::whole_part), state + 1)
		#end
		return (CFI.last_cf, state + 1)
	end

	# Check if we have reached the end of our iteration.
	if state > 9^CFI.n
		return nothing
	end

	# First, iterate the ones place.
	# iterate up if n % 2 == 1
	# otherwise iterate down
	if CFI.n % 2 == 1
		if state % 9 == 1
			CFI.last_cf[end] = 1
		else
			CFI.last_cf[end] += 1
		end
	else
		if state % 9 == 1
			CFI.last_cf[end] = 9
		else
			CFI.last_cf[end] -= 1
		end
	end

	# If odd: odd digits inc and even digits dec
	# Talking about their power of 10. Not their values.
	for k in 1:(CFI.n-1)
		if state % 9^k == 1
			# TODO we could combine some of these clauses.
			# Less readable, but less lines of code.
			# n odd, digit odd -> inc
			# remember, k is offset from digit place by -1.
			if CFI.n % 2 == 1 && (k+1) % 2 == 1
				if CFI.last_cf[length(CFI.last_cf)-k] == 9
					CFI.last_cf[length(CFI.last_cf)-k] = 1 
				else
					CFI.last_cf[length(CFI.last_cf)-k] += 1
				end
			# n odd, digit even -> dec
			elseif CFI.n % 2 == 1 && (k+1) % 2 == 0
				if CFI.last_cf[length(CFI.last_cf)-k] == 1
					CFI.last_cf[length(CFI.last_cf)-k] = 9
				else
					CFI.last_cf[length(CFI.last_cf)-k] -= 1
				end
			# n even, digit odd -> dec
			elseif CFI.n % 2 == 0 && (k+1) % 2 == 1
				if CFI.last_cf[length(CFI.last_cf)-k] == 1
					CFI.last_cf[length(CFI.last_cf)-k] = 9
				else
					CFI.last_cf[length(CFI.last_cf)-k] -= 1
				end
			# n even, digit even -> inc
			else
				if CFI.last_cf[length(CFI.last_cf)-k] == 9
					CFI.last_cf[length(CFI.last_cf)-k] = 1
				else
					CFI.last_cf[length(CFI.last_cf)-k] += 1
				end
			end
		end
	end
	#if CFI::whole_part > 0
	#	return (pushfirst(CFI.last_cf, CFI::whole_part), state + 1)
	#end
	return (CFI.last_cf, state + 1)
end

function iterate_cfs()
	#=
	Just looking for a pattern. Iterating a bunch of cf's and seeing
	what their rational numbers look like.

	Some patterns:
	[1], [1,1], [1,1,1], [1,1,1,1] generate fibonacci numbers:
	F_{n+1}/F_n
	makes sense bc this ratio converges to phi which has a cont
	fraction of [1]

	0's can be ignored.
	i.e. [1,0,1] = [1,1]

	=#

	# Here is how to iterate through...
	# first digit 0 if you don't want a whole part
	# This code lets you see the pattern.
	values = []
	for i in 0:9, j in 0:9, k in 0:9, l in 0:9, m in 0:9, n in 0:9, o in 0:9, p in 0:9
		cf = [0, i, j, k, l, m, n, o, p]
		temp = continued_fraction_to_rational_number(cf)
		append!(values, [[cf, float(temp), temp]])
	end
	sort!(values, by=x->x[2])
	#(values)
	tolerance = .05
	i = 1
	for value in values
		#println(value)
		if value[2] > 3/7 - tolerance && value[2] < 3/7
			@printf "%d \t %f \t %s \n" i value[2] value[3]
		end
		i += 1
	end
	println(length(values))

end

function main()
	#iterate_cfs()
	i = 1
	for cf in cf_iterator(11)
		cf_temp = copy(cf)
		pushfirst!(cf_temp, 0)
		value = continued_fraction_to_rational_number(cf_temp)
		tolerance = .002
		#@printf "%d \t %f \t %s \t %s \n" i float(value) repr(cf_temp) value
		#println(abs(float(value)-3/7))
		if float(value) >= 3/7 - tolerance && float(value) <= 3/7
			@printf "%d \t %f \t %s \t %s \n" i float(value) repr(cf_temp) value
			exit()
		end
		#println(i, " ", value, " ", float(value), " ", cf)
		i += 1
	end
	#iterate_cfs()
end

function main2()
	# Best I got so far:
	#[0, 2, 2, 1, 9, 1, 9, 1, 9, 1, 9, 1, 9]
	#0.42665022858132339856 	 411473//964427
	best = [0, 2, 2, 1, 9, 1, 9, 1, 9, 1, 9, 1]
	append!(best, 1)
	for i in 1:9
		println(best)
		value = continued_fraction_to_rational_number(best)
		@printf "%.20f \t %s\n" float(value) value
		best[length(best)] += 1
	end
end

@time main2()
