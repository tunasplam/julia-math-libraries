#=
	Anything linear congruence related plops in here.
	Includes Chinese Remainder Theorem (CRT)
	Includes adding enormous numbers with crt.

	TODO See 5.4.2 on how we can use CRT to solve linear congruences
	with huge values of n.
=#

include("./gcd.jl")

#=
function main()
	# THIS is how you PROPERLY make literal matricies in julia.
	#test = [1 1 5 
	#		1 2 6
	#		1 3 7]
	#test1 = [1 1000002 1000004	
	#		 1 632960 1000114]
	#test2 = [1 524160 1000096
	#		 1 207360 1000231]

	println(test1)
	println(CRT_two_equations(test1))
	println("================")
	println(test2)
	temp = CRT_two_equations(test2)
	if temp % test2[1,3] != test2[1,2] || temp % test2[2,3] != test2[2,2]
		println("eh-hem")
	end	
	println(CRT_two_equations(test2))

end
=#

function add_enormous_nums_with_CRT(x, y)
	#=
	-Pick two mutually coprime moduli smaller than float max (n1, n2)
	-Reduce x and y mod n1 and n2 and add the numbers together in each of these
	moduli,
	-CRT allows x + y modulo each of these back together for complete solution.
	
	TODO what if the number gets so big that we can't find numbers below float
	max? Do we make this recursive then?
	=#
end

function factorial_CRT(n)
	#=
	For computing HUGE factorials.
	https://www.math.tamu.edu/~fulling/chinese.pdf
	Find values m1, ... , mi to use as our moduli (all relatively prime and
	obviously less than int max)

	Default will be 65449, 65479, 65497, 65519, 65521
	TODO what if we want to have this intelligently pick values of m?

	For each value of n, find n*a_i % m_i for each value a_i from the
	residues of (n-1)!

	Then CRT the result. each row will be [1, b_i, m_i]
	=#
	# nixing the last two because of overflow when finding N in CRT.
	m_list = [65449, 65479, 65497]
	residue_list = [1, 1, 1]
	for k in 1:n
		for i in 1:length(residue_list)
			residue_list[i] = k*residue_list[i] % m_list[i]
		end
	end
	# TODO figure out the real algorithm from here on.
	# CRT the result. Create the input matrix
	input_matrix = ones(Int, length(m_list), 3)
	for i in 1:length(residue_list)
		input_matrix[i, 2] = residue_list[i]
		input_matrix[i, 3] = m_list[i]
	end
	println(input_matrix[1,3])
	println(size(input_matrix, 1))
	return CRT(input_matrix)
end

function CRT_two_equations(system)
	#=
	CRT optimized for only using two equations.
	Also assumes that the coefficients are 1.

	Two equations
	x = b1 mod n1
	x = b2 mod n2
	
	General case for when n1 n2 not coprime here:
	https://math.stackexchange.com/questions/1644677/what-to-do-if-the-modulus-is-not-coprime-in-the-chinese-remainder-theorem
	TODO TODO TODO
	ALSO has a brief explanation about how to extend this to more than two
	equations!
	=#

	# First make sure that the moduli are all coprime.
	moduli_gcd = gcd(system[1,3], system[2,3])
	# If not, then check if there is even a solution to this sytem.
	if moduli_gcd != 1
		if (system[1,2] - system[2,2]) % (moduli_gcd) != 0
			return 0
		end

		# Find bezout coefficients u and v of
		# n1*u + n2*v = gcd(m,n)
		b_coeffs = bezout_coefficients(system[1,3], system[2,3])

		# find the value lambda that we use to create a new equation
		lambda = (system[1,2] - system[2,2]) ÷ moduli_gcd

		# Now we have a solution is b1 - n1*v*lambda
		result = system[1,2] - system[1,3]*b_coeffs[2]*lambda

		# Find mod lcm to get it to the solution (closest to zero?).
		moduli_lcm = system[2,3]*system[1,3] ÷ moduli_gcd
		result %= moduli_lcm

		# all solutions are
		# x \cong result (mod lcm(n1, n2))
		# so if our result is negative, add the lcm(n1,n2) to get our
		# first nonnegative solution.
		if result < 0
			return result + moduli_lcm
		end

		return result

	else
		# Find N, product of moduli
		N = system[1,3] * system[2,3]
		# This makes an equation:
		# x = b1(n2y1) + b2(n1y2)
		# where y1, y2 are the Bezout coefficients of
		# n1*x + n2*y = 1
		b_coeffs = bezout_coefficients(system[1,3], system[2,3])

		# Now plugging in all our known values lets use solve for x
		result = system[1,2]*system[2,3]*b_coeffs[1] +
			   	 system[2,2]*system[1,3]*b_coeffs[2]
		
		result = result % N

		# We are interested in the smallest nonnegative solution, so add
		# N to get the lowest nonnegative solution
		if result < 0
			result += N
			return result
		end
		return result
	end

	if moduli_gcd != 1
		# Check to see if we can factor out the gcd.
		if isinteger(system[1,2]/moduli_gcd) && isinteger(system[2,2]/moduli_gcd)
			system[1,2] ÷= moduli_gcd; system[2,2] ÷= moduli_gcd
			system[1,3] ÷= moduli_gcd; system[2,3] ÷= moduli_gcd
		else
			# No solution
			return 0
		end
	end

	
end

function CRT(system)
	#=
	Takes in a matrix nx3 where n are all the moduli and each row
	is [ai, bi, bi] meaning a_i*x = b_i (mod n_i)

	See Note 5.5.3 in the NT Text! Adding large numbers!

	TODO THIS IS BORKED NEEDS TO BE FIXED PROBABLY REDO FROM GROUND UP.
	=#

	# first make sure that the moduli are all coprime.
	# If they are not, then see if we can take out the gcd from all of the terms
	# which are not one.
	# This makes sure that the SAME gcd is taken from ALL rows, not just the gcd
	# of each row.
	gcd_of_moduli = gcd(system[1, 3], system[2,3])
	for row_i in 1:size(system, 1)
		for row_i2 in row_i+1:size(system, 1)
			gcd_of_row_moduli = gcd(system[row_i, 3], system[row_i2, 3])
			
			# Make sure that all of the pairs have the SAME gcd of moduli.
			if gcd_of_row_moduli != gcd_of_moduli
				throw(ErrorException("Issue with the moduli. Not coprime and not factorable."))
				return
			end
			
			if gcd_of_row_moduli != 1
				# First, try and take out the gcd from all entries that are not 1.
				# If any of these values does not divide cleanly, no solution.
				# TODO it shouldn't be entries that are not 1, its entries that are
				# not the coefficients. If any values b_i n_i are 1 then this won't
				# work!
				for row_i in 1:size(system, 1), j in 1:3
					value = system[row_i, j]/gcd_of_row_moduli
					if value >= 1 && isinteger(value)
						system[row_i, j] = value
					elseif value >= 1 && !isinteger(value)
						#throw(ErrorException("No solution. Make sure either all modular bases are pairwise coprime OR that all non-one values can have the same factors taken out."))
						return 0
					end
				end
			end
		end
	end

	# For our current problem, none will have coefficients.
	#=
	# If x has coefficients a then simplify
	for row_i in 1:size(system, 1)
		if system[row_i, 1] != 1
			new_b = simplify_congruence_with_congruence(system[row_i, 1], system[row_i, 2], system[row_i, 3])
			system[row_i, 1], system[row_i, 2] = 1, new_b
		end
	end
	=#
	N = 1
	for row_i in 1:size(system, 1)
		N *= system[row_i, 3]
	end

	# Find the "complements" of each moduli. Find the inverse of each.
	# Then multiply this inverse with a and b for associated equation
	# to get a value. Sum these values up for each equation to get the answer.
	#=
	TODO TODO TODO TODO TODO TODO
	OLD WAY NOT ACCURATE BETTER NOW WITH BEZOUT COEFFICIENTS BUT NOT TESTED
	FOR MORE THAN 2 EQUATIONS. IN FACT, DOES NOT EVEN WORK ANYMORE FOR MORE
	THAN 2.
	answer = 0
	for row_i in 1:size(system, 1)
		complement = N÷system[row_i, 3]
		println(Int(modular_inverse(N/system[row_i, 3],
									  system[row_i, 3])*system[row_i, 2]*complement))
		answer += Int(modular_inverse(N/system[row_i, 3],
									  system[row_i, 3])*system[row_i, 2]*complement)
	end
	=#
	# Find the Bezout cofficients Just use one of the equations, they should
	# be the same for all of the equations in the system.
	complement = N÷system[1, 3]
	coefficients = bezout_coefficients(N/system[1, 3], system[1, 3])
	# once they are found, do x = b_1*n_2*bezout_1 + b_2*n_1*bezout_2
	# Note that the n and b's are swapped!
	result = Int(system[1,2]*coefficients[1]*system[2,3] + system[2,2]*coefficients[2]*system[1,3])
	# Multiply by the gcd that was taken out if the moduli were not relatively coprime.

	return result % N * gcd_of_moduli
end

function modular_inverse(a, n)
	#=
	Finds the modular inverse using the bezout coefficients which are found
	using the extended euclidean algorithm (see bezout_coefficients in gcd.jl)
	bezout coefficients here referred to as s and t.
	so...
	ns + at = 1 is what we are interested in solving.
	Since we are working mod n, taking mod n of everything takes out the ns term
	Yields,
	at = 1 (mod n) [it drops since it is a multiple of n]
	Thus, t % n is the modular inverse of a mod n
	=#
	# Can crash is b > a or the third arg is wrong (will always be 1
	# here since we want to solve ns + at = 1)
	res = bezout_coefficients(n, a, 1)
	println(res)
	ans = res[2] % n 
	# TODO NEGATIVE RESULT? THIS IS A BANDAGE> DUNOO IF IT ALWAYS WORKS.
	if ans < 0
		return n + ans
	end
	return ans
end

function modular_inverse_brute_force(a, n)
	#=
	Find the modular invserse of a mod n.
	i.e. largest nonnegative solutions to
	ax = 1 ( mod n )
	note that only exists if a and n are coprime.
	
	TODO
	Note that incorrectly returns 1 for a values of 1.
	=#
	if gcd(a,n) != 1
		return Nothing
	end

	# can only pair with numbers that are coprime with n.
	# TODO so the looping can be made better I bet.
	inverse = 0
	for x in 2:n
		if (a * x) % n == 1
			inverse = x
		end
	end
	return inverse
end

function simplify_congruence_with_congruence(a, b, n)
	#=
	Use inverse idea simplify an expression ax = b mod n to
	a congruence without a coefficient.

	returns the new value of b (since a will be 1 and n unchanged.)
	=#

	a_inverse = modular_inverse(a, n)

	# Now multiply a and b by a_inverse and take the mod n
	# Will always result in a = 1
	b = (b * a_inverse) % n
	return b

end

function divide_mod(a, b, m)
	a %= m
	inv = modular_inverse(b, m)
	if inv == -1
		println("Division not defined!")
		return NaN
	end
	return (inv*a) % m
end

#function main()
#	println(divide_mod(10, 5, 3))
#	println(divide_mod(120, 10, 5))
#end
