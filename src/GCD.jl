#=
	Anything related to finding the GCD of two numbers goes here.
=#

function bezout_coefficients(a::Integer, b::Integer, gcd_a_b_case::Bool=true)::Tuple{Int,Int}
#=
	https://en.wikipedia.org/wiki/Extended_Euclidean_algorithm
	For more on algorithm see gcd_extended_euclidean()

	Note that we generate t_i and s_i (Bezout Coefficients).
	These are useful for solving the equations
		ax + by = 0 (for all values a and b)
	AND
		ax + by = gcd(a,b)
	And therefore (for gcd(a,b) = 1)
		ax + by = 1
	these magic values of a and b are s_i, t_i for the =0 equation
	and s_{i-1} t_{i-1} for the =gcd(a,b) equation.

	These values can be used to find the modular inverse quickly!

	gcd_a_b_case as TRUE means we default to returning the solutions to the
	gcd(a, b) equation.
	(s_{i-1}, t_{i-1})
	gcd_a_b_case as FALSE means we return the solutions to the =0 equation
	(s_i, t_i)
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
		new_r_i = r_i_minus_one - q_i*r_i
		new_s_i = s_i_minus_one - q_i * s_i
		new_t_i = t_i_minus_one - q_i * t_i

		r_i_minus_one = r_i
		r_i = new_r_i
		t_i_minus_one = t_i
		t_i = new_t_i
		s_i_minus_one = s_i
		s_i = new_s_i

	end
	if gcd_a_b_case
		return (s_i_minus_one, t_i_minus_one)
	else
		return (s_i, t_i)
	end
end

function gcd(a::Integer, b::Integer)::Integer
	#=
	NOTE don't use this. just use Base.gcd
	its fun to use this but no way is this optimized.

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

function gcd(A::Vector{Int})::Int
	#=
	Returns the gcd of a given list of numbers.
	Factors each number and finds the highest common element in the list
	=#
	factors = map(divisors, A)

	# flatten the factors but only keep values that are present in all
	# lists
	unique_factors = Iterators.flatten(factors) |>
	unique |>
	reverse

	for x in unique_factors
		if all(x in factors[i] for i in eachindex(factors))
			# iterating from largest to smallest so return first
			# common divisor found
			return x
		end
	end
	return 1
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
