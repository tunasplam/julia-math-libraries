function find_last_y_digits(base, power, num_digits)
#=
	Modular Exponentiation.
	https://www.nctm.org/tmf/library/drmath/view/66970.html

	Find the last y digits of a given exponent with a given
	base and power

	Includes a nice way to convert to binary:
	bitstring(UInt(num))

	TODO May need to be made to accomate bigs!
=#

	# Start by getting our relevant powers of 2.
	# Grabs us the powers of 2 that we need to calculate
	power_2, powers_of_2 = 0, []
	for bit in reverse(bitstring(UInt(power)))
		if bit == '1'
			append!(powers_of_2, power_2)
		end
		power_2 += 1
	end

	# Keep moving up in powers until we clear the list of needed powers.
	product = 1
	# Start with power 0, if present
	if 0 in powers_of_2
		product *= big(base)
		product %= 10^num_digits
		filter!(x -> x != 0, powers_of_2)
	end	

	# Now prime the algorithm with i = 1
	k_i = (big(base) ^ 2) % (10^num_digits)
	if 1 in powers_of_2
		product *= k_i
		filter!(x -> x != 0, powers_of_2)
	end

	i = 2
	while(length(powers_of_2) > 0)
		k_i = (k_i ^ 2) % (10^num_digits)
		#println(i, " ", k_i)
		if i in powers_of_2
			filter!(x -> x != i, powers_of_2)
			product *= k_i
			product %= 10^num_digits
		end
		i += 1
	end
	return product
end