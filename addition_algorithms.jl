#=
	Basically just the Lattice Algorithm for adding large numbers.

	https://faculty.atu.edu/mfinan/2033/section12.pdf

	Includes our first generator in julia, the fibonnaci generator.
	See http://slendermeans.org/julia-iterators.html
=#

using Printf

function test_accuracy(trials)
	# Grab random numbers and use to test accuracy.
	for i in 1:trials ÷ 3
		nums = rand(Int64, 2)
		if lattice(nums[1], nums[2]) != nums[1] + nums[2]
			println("Problem ", nums[1], " ", nums[2])
		end
	end
	for i in 1:trials ÷ 3
		nums = rand(Int128, 2)
		if lattice(nums[1], nums[2]) != nums[1] + nums[2]
			println("Problem ", nums[1], " ", nums[2])
		end
	
	end
	for i in 1:trials ÷ 3
		if lattice(nums[1], nums[2]) != nums[1] + nums[2]
			println("Problem ", nums[1], " ", nums[2])
		end
	end
end


function fibonnaci(n)
#=
	Generate nth term of sequence
=#
	return fibonnaci_step(1,2,n-4)
end

function fibonnaci_step(n_1, n_2, n)
	if n == 0
		return lattice(n_1, n_2)
	else
		return fibonnaci_step(n_2, lattice(n_1, n_2), n-1)
	end
end

function lattice(x, y)
#=
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
	# Order the numbers so that x is biggest
	if x < y
		temp = x
		x = y
		y = temp
	end

	result = []
	x, y = digitize(x), digitize(y)
	a_1, a_2 = 0, 0
	# if x has more digits, then just copy over the leftovers.
	for i in 1:length(y)
		digit_sum = x[i] + y[i]
		b_2 = digit_sum % 10
		a_2 = digit_sum ÷ 10
		if a_1 + b_2 == 10
			push!(result, 0)
			a_2 += 1
		else
			push!(result, b_2 + a_1)
		end
		a_1 = a_2
	end
	# carry a_2 at the end if more digits in x.
	# otherwise, append it.
	if a_2 > 0
		if length(x) > length(y)
			x[length(y)+1] += 1
		else
			push!(result, a_2)
		end
	end
	
	# extra digits from x need to be appended.
	for digit in x[length(y)+1:length(x)]
		push!(result, digit)
	end 

	# format the answer.. reverse and join.
	reverse!(result)
	result = join(result)
	#println(result)
	return parse(BigInt, result)
end

function digitize(x)
#=
	Splits number into its digits.
	Note that the results are REVERSED.
	i.e. 10 -> [0, 1]
=#
	digits = []
	# This is do-while in julia
	while true
		append!(digits, x % 10)
		x ÷= 10
		x > 0 || break
	end
	return digits

end
