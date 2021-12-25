#=
	Easy algebra solvers like quadratic formula
=#

include("./factor_number.jl")
using Printf

function quadratic_formula(a, b, c;
		sol_type::String="both", formatted::Bool=false, verbose::Bool=false)
	#=
	Can have three args for different types of answers
	sol_type = both, minus, or plus.
	For both, returns a list

	formatted means returns formatted (x + sqrt(y))/z
	so returns list [x, y, z]. Two lists if both solutions desired.

	Before it does any of this though it checks the determinate.
	So it could return nothing
	=#	

	if !determinate(a,b,c)
		return
	end

	if formatted == false
		sol1 = (-b + sqrt(b^2 - 4*a*c))/(2*a)
		sol2 = (-b - sqrt(b^2 - 4*a*c))/(2*a)

		if sol_type == "plus" 
			return sol1
		elseif sol_type == "minus"
			return sol2
		elseif sol_type == "both"
			return [sol1, sol2]
		end
	
	elseif formatted == true
		x = -b
		y = b^2 - 4*a*c
		z = 2*a
		# Don't worry about the gcd unless everything is an integer
		if isinteger(x) && isinteger(y) && isinteger(z)
			println(x,y,z)
			# Note that things get wonky if one of the values is zero..
			if y == 0
				if gcd(x, z) > 1
					common_factor = gcd(x,z)
					return [x/common_factor, 0, z/common_factor]
				end
			elseif x == 0
				if gcd(y[1], z) > 1
					common_factor = gcd(y[1], z)
					z /= common_factor
					y[1] /= common_factor
					y = undo_simplest_radical_form
					return [0, y, z]
				end
			end

			y = simplest_radical_form(y)
			println(y, " ", gcd(x,z))
			common_factor = gcd(x, z)
			if common_factor > 1 && gcd(x, y[1]) == common_factor && 
					gcd(y[1], z) == common_factor
				println("Yep")
				x /= common_factor 
				y[1] /= common_factor 
				z /= common_factor 
			end
			# undo the simplest radical form so that output is nicer.
			y = undo_simplest_radical_form(y)
		end

		if sol_type == "plus"
			if verbose
				@printf "(%d + sqrt(%d))/%d" x y z
			end
			return [x, y, z]

		elseif sol_type == "minus"
			if verbose
				@printf "(%d - sqrt(%d))/%d" x y z
			end
			return [x, (-1)*y, z]
		elseif sol_type == "both"
			if verbose
				@printf "(%d +- sqrt(%d))/%d" x y z
			end
			return [[x, y, z], [x, (-1)*y, z]]
		end
	end
	println("Something went wrong with finding the solutions to the quadratic equation.")
end

function determinate(a, b, c)
	# returns true if theres a solution and false if not
	det = b^2 - 4*a*c
	if det >= 0
		return true
	end
	return false
end

function simplest_radical_form(n)
	#=
	returns a tuple (a, b)
	where a is the value on the outisde and b the value
	on the inside.
	Note that if a perfect square then b = 1
	If not reducible, a = 1
	=#

	p_fact = prime_factorize(n)
	a = 1; b = n
	for p in p_fact
		# If you have pairs of prime factors, take one prime factor
		# out for each pair.
		num_pairs = p[2] ÷ 2
		if num_pairs > 0
			b ÷= p[1]^(num_pairs*2)
			a *= p[1]^num_pairs
		end
	end
	return (a, b)
end

function undo_simplest_radical_form(n)
	#=
	Exactly what it says it does. Takes [a, b]
	and returns x = b*a^2 where x is the new value under the radical
	=#
	return n[2]*n[1]^2
end
