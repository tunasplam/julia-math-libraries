#=
	Everything regarding squarefree numbers.
	Mobius formula stuff in here too
=#

function generate_mobius_list(n)
	#=
	Generate first n entries of mobius list as quickly as possible.
	A few things to note:
	- it is multiplicative.
	- If mu(n) == 1 || -1, then all multiples of n = 0

	Try list and dict and see what is better. Need 5493321 entries at least.
	=#
	results = [2 for i in 1:n]
	results[1] = 1
	#results = Dict(1 => 1)
	for num in 2:n
		if results[num] == 2
			res = mobius(num)
			results[num] = res
			# TODO faster to do integer division?
			for k in 2:floor(Int, log(num, n))
				results[num^k] = 0
			end
		end
	end
	return results
end

function mobius(n)
	#=
	https://en.wikipedia.org/wiki/M%C3%B6bius_function#:~:text=The%20M%C3%B6bius%20function%20is%20multiplicative,a%20and%20b%20are%20coprime.&text=The%20equality%20above%20leads%20to,of%20multiplicative%20and%20arithmetic%20functions.
	see properties heading
	=#
	total = 0
	for k in 1:n
		if gcd(k, n) == 1
			# Using euler's formula and noting that we only care about
			# the real part.
			total += cos(2*MathConstants.pi*(k/n))
		end
	end
	return(round(total))
end

function gcd(a,b)
	if a == 0
		return b
	end
	return gcd(b%a, a)
end

function main()
	@time res = generate_mobius_list(10^4)
	print(sum(res))
end

main()