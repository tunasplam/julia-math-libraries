# anything regarding computing the addition of two numbers


function add_lattice_alg(x::Int, y::Int)::BigInt
#=
	TODO benchmark this against regular Int addition
	TODO BigInt version and benchmark this against regular BigInt addition...

	https://faculty.atu.edu/mfinan/2033/section12.pdf

	x > y
	Split the numbers into array of digits.
	iterate through elements of array:
	
	- a_1, b_1 = 0
	- add the digits and split into a_2 (tens) and b_2 (ones)
	- add together b_2 and a_1 and make that a digit on ans
	- if a_1 + b_2 = 10:
		append the 0, add 1 to a_2
	- a_1 = b_2
	repeat

	At the end:
	- if more digits in x
		carry a_2 to next digit in x
	- else  
		append a_2 (carried over tens place from last addition)
	- append extra digits from x (if present)
=#
	if x < 0
		throw(DomainError(x, "must be positive or 0"))
	end

	if y < 0
		throw(DomainError(y, "must be positive or 0"))
	end

	# Order the numbers so that x is biggest
	if x < y
		temp = x
		x = y
		y = temp
	end

	result = []
	x, y = digits(x), digits(y)
	a_1, a_2 = 0, 0
	# if x has more digits, then just copy over the leftovers.
	for i in 1:length(y)
		@inbounds @fastmath digit_sum = x[i] + y[i]
		@fastmath b_2 = digit_sum % 10
		@fastmath a_2 = digit_sum ÷ 10
		@fastmath if a_1 + b_2 == 10
			push!(result, 0)
			@fastmath a_2 += 1
		else
			@fastmath push!(result, b_2 + a_1)
		end
		a_1 = a_2
	end
	# carry a_2 at the end if more digits in x.
	# otherwise, append it.
	if a_2 > 0
		if length(x) > length(y)
			@inbounds @fastmath x[length(y)+1] += 1
		else
			push!(result, a_2)
		end
	end

	# extra digits from x need to be appended.
	@inbounds for digit in x[length(y)+1:length(x)]
		push!(result, digit)
	end 

	# format the answer.. reverse and join.
	reverse!(result)
	result = join(result, "")
	return parse(BigInt, result)
end
