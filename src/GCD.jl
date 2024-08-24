# euclidean algorithm to find gcd of two numbers

using Printf

function bezout_coefficients(a::Int, b::Int, solution::Int=1)::Tuple{Int,Int}
#=
	https://en.wikipedia.org/wiki/Extended_Euclidean_algorithm
	For more on algorithm see gcd_extended_euclidean()

	Note that we generate t_i and s_i (Bezout Coefficients).
	These are useful for solving the equations
		ax + by = 0 (for all values a and b (I THINK))
	AND
		ax + by = gcd(a,b)
	And therefore (for gcd(a,b) = 1)
		ax + by = 1
	these magic values of a and b are s_i, t_i for the =0 equation
	and s_{i-1} t_{i-1} for the =gcd(a,b) equation.

	These values can be used to find the modular inverse quickly!
	
	solution = 1 means we default to returning the solutions to the
	gcd(a, b) equation.
	(s_{i-1}, t_{i-1})
	solution = 0 means we return the solutions to the =0 equation
	(s_i, t_i)
	=#
	if b > a
		temp = b
		b = a
		a = temp
	end
	if solution != 0 && solution != 1
		println("Read the docs on the the solution paramater for bezout_coefficients in gcd.jl")
		throw(ErrorException("Invalid value for solution type for bezout_coefficients."))
	end

	r_i_minus_one = a; r_i = b
	s_i_minus_one = 1; t_i_minus_one = 0
	s_i = 0; t_i = 1
	q_i = 0
	# Keep going until the remainder of
	# r_{i-1}/r_i = 0
	# r_i is 0, then return the value of r_i_minus_one
	# That is the gcd.
	while r_i > 0
		q_i = r_i_minus_one ÷ r_i
		#@printf "q_i: %d / %d = %d\n" r_i_minus_one r_i q_i
		new_r_i = r_i_minus_one - q_i*r_i
		#@printf "r_{i+1}: %d - %d * %d = %d\n" r_i_minus_one q_i r_i new_r_i
		new_s_i = s_i_minus_one - q_i * s_i
		#@printf "s_{i+1}: %d - %d * %d = %d\n" s_i_minus_one q_i r_i new_s_i
		new_t_i = t_i_minus_one - q_i * t_i
		#@printf "t_{i+1}: %d - %d * %d = %d\n" t_i_minus_one q_i r_i new_t_i

		r_i_minus_one = r_i
		r_i = new_r_i
		t_i_minus_one = t_i
		t_i = new_t_i
		s_i_minus_one = s_i
		s_i = new_s_i

	end
	if solution == 1
		return (s_i_minus_one, t_i_minus_one)
	elseif solution == 0
		return (s_i, t_i)
	end
end

function gcd(a::Int, b::Int)::Int
	#=
	https://en.wikipedia.org/wiki/Extended_Euclidean_algorithm
	Uses extended euclidean algorithm to find the gcd of two numbers.
	Also keeps track of the bezout coefficients x_i and t_i where,
	for each step in the algorithm, gcd(a,b) = r_k = as_k + bt_k

	For each value of i until the exit condition is reached, just use
	the simple recurrence relations for q_i, r_i, s_i, and t_i

	A COUPLE OF OTHER THINGS THAT CAN BE FOUND FROM THIS.
	Note that we generate t_i and s_i (Bezout Coefficients). These
	are useful for solving the equations
		ax + by = 0 (for all values a and b (I THINK))
	AND
		ax + by = gcd(a,b)
	And therefore (for gcd(a,b) = 1)
		ax + by = gcd(a,b)
	these magic values of a and b are s_i, t_i for the =0 equation
	and s_{i-1} t_{i-1} for the =gcd(a,b) equation.

	These values can be used to find the modular inverse quickly!
	=#
	if b > a
		temp = b
		b = a
		a = temp
	end

	r_i_minus_one = a; r_i = b
	s_i_minus_one = 1; t_i_minus_one = 0
	s_i = 0; t_i = 1
	q_i = 0
	# Keep going until the remainder of
	# r_{i-1}/r_i = 0
	# r_i is 0, then return the value of r_i_minus_one
	# That is the gcd.
	while r_i > 0
		q_i = r_i_minus_one ÷ r_i
		#@printf "q_i: %d / %d = %d\n" r_i_minus_one r_i q_i
		new_r_i = r_i_minus_one - q_i*r_i
		#@printf "r_{i+1}: %d - %d * %d = %d\n" r_i_minus_one q_i r_i new_r_i
		new_s_i = s_i_minus_one - q_i * s_i
		#@printf "s_{i+1}: %d - %d * %d = %d\n" s_i_minus_one q_i r_i new_s_i
		new_t_i = t_i_minus_one - q_i * t_i
		#@printf "t_{i+1}: %d - %d * %d = %d\n" t_i_minus_one q_i r_i new_t_i

		r_i_minus_one = r_i
		r_i = new_r_i
		t_i_minus_one = t_i
		t_i = new_t_i
		s_i_minus_one = s_i
		s_i = new_s_i
	end

	return r_i_minus_one
end

function gcd_binary(a::Int, b::Int)::Int
	#=
	https://en.wikipedia.org/wiki/Binary_GCD_algorithm
	Uses these three identities repeatively:
	1. gcd(0, b) = gcd(b, 0) = b
	2. gcd(2a, 2b) = 2 * gcd(a, b)
	3. gcd(2a, b) = gcd(a, b) if b is odd.
	   gcd(a, 2b) = gcd(a, b) if a is odd.
	4. gcd(a, b) = gcd(|a - b|, min(a,b)) if a and b are both odd.
	Supposedly Chinese knew about this ~200 AD... geniuses.

	Much slower than the simple recursive script we are using now.
	=#
	
	# base case gcd(n, n) = n
	if a == b
		return a
	end

	# identity 1: gcd(0, n) = gcd(n, 0) = n
	if a == 0
		return a
	end
	if b == 0
		return b
	end

	# a odd
	if a & 1 == 1
		# b even
		if b % 2 == 0
			# identity 3
			return gcd_binary(a, b ÷ 2)
		end
		# identities 4 and 3
		if a > b
			return gcd_binary((a - b) ÷ 2, b)
		else
			return gcd_binary((b - a) ÷ 2, a)
		end
	# a even
	else
		# b odd
		if b & 1 == 1
			# identity 3
			return gcd_binary(a ÷ 2, b)
		# both a and b even
		else
			# identity 2
			return 2 * gcd_binary(a ÷ 2, b ÷ 2)
		end
	end
end
