include("./factor_number.jl")
include("./linear_congruences.jl")


function main()
	lim = 10^9
	println(last_k_digits_before_trailing_zeros_in_n_factorial(lim))
end

mutable struct Factorial{T<:Integer}
	prev_n::T
	n::Int
end
factorial(n::Integer) = Factorial(1, n)
factorial(n::Integer, T::Type) = Factorial{T}(1,n)

# The return tuples are: (n!, n)
function Base.iterate(F::Factorial, state=1)
	if state == 1
		(2,2)
	elseif state > F.n
		nothing
	else
		F.prev_n = F.prev_n*state
		(F.prev_n, state + 1)
	end
end

mutable struct Factorial_mod_k{T<:Integer}
	prev_n::T
	n::Int
	k::Int
end
factorial_mod_k(n::Integer, k::Integer) = Factorial_mod_k(1, n, k)
factorial_mod_k(n::Integer, k::Integer, T::Type) = Factorial_mod_k{T}(1, n, k)

function Base.iterate(F::Factorial_mod_k, state=1)
	if state == 1
		(2 % F.k, 2)
	elseif state > F.n
		nothing
	else
		F.prev_n = F.prev_n*state % F.k
		(F.prev_n, state + 1)
	end
end

function last_k_digits_before_trailing_zeros_in_n_factorial(n)
	#=
	As the title implies.
	So for 11! = 39916800 returns 99168

	How it works:
	Every time a 5 appears in the prime factorization of i then a zero is added
	so for 25 = 5^2 2 fives are added.
	
	Then mod 10^k

	This is too slow. ! 80s for 10^10 and we need 10^12.
	There has to be another way.

	64704
	So yeah n = 10^9 = 64704 isnt even right. might punt.
	should be 38144
	=#
	fact = 1
	for i in 1:n
		# works until i = a multiple of 10^5 which gives us 0
		# BUT every power of 10 will be the same
		# as the value before. So skip if log(10,i ) is an integer
		# But checking this will sloowww us dowwwwn. maybe cut up the loops.
		#if isinteger(log(10, i))
		#	continue
		#end
		if i % 10^5 == 0
			fact *= i
		else
			fact *= (i % 10^5)
		end

		while fact % 10 == 0
			fact ÷= 10
			#println(i, "!")
		end
		#println("====================================================")
		fact %= 10^5
		#println(i, " ", fact)
	end
	return fact
end

function lowest_k_such_that_n_divides_k_factorial(n)
	#=
	A mouthful but an interesting algorithm I guess.

	- Find prime factorization of n
	- For each prime factor p with power r,
	  find the lowest k_i s.t. p_i^r_i | (k_i)!
	- The answer for n is going to be the max of the k's
	  found in the previous step.

	TODO combine with our factorial_mod_k generator to
	get an upper bound on how high you need to generate until
	0's are reached.
	ALSO use that to verify these findings! I am pretty certain
	that this is a project euler problem!
	=#

	p_fact = prime_factorize(n)
	max_k = 0
	for factor in p_fact
		# find lowest k_i s.t. p_t^r_i | (k_i)!
		# TODO TODO TODO TODO
		# Here is a brute force way. I am CONVINCED that there is
		# a cleaner way of doing this.
		num_factors = 0
		k = 0
		# instead of 10 the power of the prime we are checking.
		while num_factors < factor[2]
			num_factors += 1
			k += 1
			power = 1
			while k >= factor[1]^power
				if k % factor[1]^power == 0
					#@printf "Adding 1 for %d\n" k
					num_factors += 1
				end
				power += 1
			end
		end
		if factor[1] * k > max_k
			max_k = factor[1] * k
		end	
	end
	return max_k
end

function factorial_mod(n, m)
	#=
	Figure out what n! % m is!
	Note that mod works nice splitting up across multiplication.
	So... if (n - 1)! = k (mod m) then
	n! = n(n-1)! = n * k (mod n)
	thus
	n! = n * k (mod m)
	Just keep multiplying by n and modding!
	=#
	product = 1
	for k in 1:n
		product = (product * k) % m
	end
	return product
end

function last_k_digits_of_n_factorial(n, k)
	fact = 1
	for i in 1:n
		fact *= i
		fact %= 10^k
	end
	return fact
end

@time main()