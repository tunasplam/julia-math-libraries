#=
	Everything regarding the basics of quadratic equations
=#

function solve_quadratic(a::Int, b::Int, c::Int)::Vector{Float64}
	#=
	Returns a list of the solutions to the quadratic equation defined
	by a*x^2 + b*x + c = 0
	=#	

	if quadratic_determinate(a,b,c) == 0
		return []
	end

	@fastmath return unique([(-b + sqrt(b^2 - 4*a*c))/(2a), (-b - sqrt(b^2 - 4*a*c))/(2a)])
end

function quadratic_determinate(a::Int, b::Int, c::Int)::Int
	# returns the determinate of a given quadratic equation
	@fastmath return b^2 - 4*a*c
end

#=
NOTE the stuff below is cool but havent really messed with it lately and
its pretty useless
=#

function pretty_solve_quadratic(a::Int, b::Int, c::Int)::Vector{String}
	x = -b
	y = quadratic_determinate(a, b, c)
	z = 2a
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
