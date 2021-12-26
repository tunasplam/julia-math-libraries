#=
	WHOOOO DOGGIE!

	TODO: THE BEST FUNCTION FOR P(n)
	See answer thread to 78. Particularly Euler's response.
	TODO: Count of palindromic compositions of number n (Section 9.4.3)
	Also fibonnacci palindromes (Section 9.4.4)
	TODO: Partition with largest product. This is covered in the You do the
	Maths section. Its the partitions comprised of only 2's and 3's.
=#

include("./polynomials.jl")
include("./divisors.jl")
include("./factor_number.jl")
using Printf

function partition_recurrence_equation_uses_sigma(num)
#=
	Gets the number of partitions for each number.

	Look at equation 13 in this:
	https://mathworld.wolfram.com/PartitionFunctionP.html

	We are gonna use a lookup table bc otherwise itll be crazy
	to do otherwise.

	Has to be n > 2
	Need the sigma function (divisor counter)
=#
	# Prime with terms 1 and 2. NOTE OEIS starts with n = 0!
	P = [1, 2]
	# need up to sigma(num) generated.
	sigma = generate_sigma_one(num)
	for n in 3:num
		total = 0
		for k in 0:(n-1)
			total += sigma[n-k] * get(P, k, 1)
		end
		total ÷= n
		append!(P, total)
	end
	return P
end

# =====================================================================

function A000041(n::Int64)
	#=
	First n terms
	=#
	results = zeros(Int, n)
	for i in 1:n
		results[i] = number_of_partitions(i)
	end
	return results
end

function number_of_partitions(n::Int64)
	#=http://www.maths.surrey.ac.uk/hosted-sites/R.Knott/Partitions/partitions.html#genpents
	See section 9-2.
	TODO lets also do a list build approach too.
	http://oeis.org/A000041
	=#
	total = 0
	for i in 1:n
		total += number_of_partitions_size_k(n, i)
	end
	return total
end

function number_of_partitions_size_k(n::Int64, k::Int64)
	#=http://www.maths.surrey.ac.uk/hosted-sites/R.Knott/Partitions/partitions.html#genpents
	See section 9-2.
	Partitions (multisets/bags with repetition)
	The number of multisets of k positive numbers with sum n

	=#
	if k < 1 || n < k
		return 0
	elseif k == 1
		return 1
	else
		return number_of_partitions_size_k(n-1,k-1)+number_of_partitions_size_k(n-k,k)
	end
end

# =====================================================================

function A000009(n::Int)
	#=
	Partition of n into distinct values 'k' which sum to n.
	=#
	result = zeros(Int, n)
	for i in 1:length(result)
		result[i] = number_of_partitions_distinct_numbers(i)
	end
	return result
end

function number_of_partitions_distinct_numbers(n::Int64)
	#=
	Section 9.3
	Counts the number of sets of (distinct) numbers whose sum is n
	Why the limit? Dunno. Figure it out. I guess thats the largest size
	k that can create a set of distinct integers summing to n.
	https://oeis.org/A000009
	=#
	lim = floor(Int, (sqrt(8*n+1)-1)/2)
	total = 0
	for i in 1:lim
		total += number_of_partitions_distinct_numbers_size_k(n, i)
	end
	return total
end

function number_of_partitions_distinct_numbers_size_k(n::Int64, k::Int64)
	#=
	Section 9.3
	Counts the number of sets of (distinct) numbers whose sum is n
	=#
	if k < 1 || n < k 
		return 0
	elseif k == 1
		return 1
	else
		return number_of_partitions_distinct_numbers_size_k(n-k,k-1) + 
			   number_of_partitions_distinct_numbers_size_k(n-k,k)
	end
end

# =====================================================================
function A011782(n)
	#=
	Number of sequences of positive integers (repetition allowed)
	who sum to n. These numbers are entries of pascal's triangle.
	The sum of nth row is nth entry of this sequence.
	The sum of the nth row in pascal's triangle is 2^n
	Hence, the simple function. Offset by -1 bc starting at TOP of triangle.
	=#
	results = zeros(Int, n)
	for i in 1:n
		results[i] = 2^(i-1)
	end
	return results
end

function number_of_compositions_with_repetition(n::Int64)
	#=
	Section 9.4
	Number of sequences of positive integers (repetition allowed)
	who sum to n.
	NOTE that this is a recurrence for the binomial numbers!
	Hence, 2^(n-1) See A011782 function for more of an explanation.
	=#
	return 2^(n-1)
end

function number_of_compositions_with_repetition_size_k(n::Int64, k::Int64)
	#=
	Section 9.4
	Number of sequences of k positive integers (repetition allowed)
	who sum to n.
	NOTE that this is a recurrence for the binomial numbers!
	=#
	if k < 1 || n < k
		return 0
	elseif k == 1
		return 1
	else
		return number_of_compositions_with_repetition_size_k(n-1,k-1) +
			   number_of_compositions_with_repetition_size_k(n-1,k)
	end
end

# =====================================================================

function A032020(n::Int64)
	#=
	9.5 number of sequences of distinct positive numbers whose sum is n.
	TODO THIS SEQUENCE NOT WORKING FIGURE IT OUT LATER.
	=#
	results = zeros(Int, n)
	for i in 1:n
		results[i] = compositions_without_repetition(i)
	end
	return results
end

function compositions_without_repetition(n::Int64)
	#=
	9.5 number of sequences of distinct positive numbers whose sum is n.
	=#
	total = 0
	for i in 1:n
		total += compositions_without_repetition_size_k(n, i)
	end
	return total
end

function compositions_without_repetition_size_k(n::Int64, k::Int64)
	#=
	9.5 Number of sequences of k distinct positive numbers whose sum
	is n.
	=#
	if k < 1 || n < k
		return 0
	elseif k == 1
		return 1
	else
		return compositions_without_repetition_size_k(n-k,k) +
			   compositions_without_repetition_size_k(n-k,k-1)
    end
end

# =====================================================================


function generate_partitions_lexicographically(n)
#=  https://www.quora.com/Algorithm-to-split-a-number-into-different-ordered-group-such-that-sum-of-those-numbers-make-original-number
	originally was thinking a recursive way. And there is a recursive way on that link
	but it is not very clear. This is going to use a small group of numbers
	so just bruteforce it lexicographically.
=#	
	case = []
	cases = []
	count = 1
	# Prime with the 1's case.
	for i in 1:n
		append!(case, 1)
	end
	while true
		# Keep adding on 1's until you have n 1's.
		while sum(case) != n
			append!(case, 1)
		end
		# Okay, now remove last number and increase second to last by 1.
		# Keep going from there.
		#println(case)
		append!(cases, [copy(case)])
		pop!(case)
		count += 1
		if length(case) == 0
			return cases
		end
		case[length(case)] += 1
	end
	return cases
end

function A005252(n)
	#=
	For problem 114.
	https://oeis.org/search?q=1%2C1%2C2%2C4%2C7%2C11%2C17%2C27%2C44%2C72&language=english&go=Search
	=#
	total = 0
	# add one to whatever value you want to use
	n += 1
	for k in 0:floor(Int, n/4)
		total += binomial(n-2*k, 2*k)
	end
	return total
end

function A000792(n)
	#=
	For p374. Product of the values of the maximum partition
	=#
end

function general_pentagonal_number(n)
	#=
	A001318 general bc of the plus minus.
	(3n^2 +- n)/2 n = 1, 2, 3, ...
	How are we going to do the plus, minus? if you want the value for
	minus n then input negative n.
	=#
	return (3*n^2-n)÷2
end

function partitions_of_n_from_set_S(n::Int, S::Array{Int})
	#=
	S set of values. sort them big to small.

	Note that the partitions are PRINTED as they are finalized.
	returns "1" if successful. Dunno if its even necessary.

	An algorithm that has been eluding us that may unlock so many solutions,
	yet finally may have figured it out.

	Note that for now this only works if 1 is in S (and it may be faster
	that way so if we make another function that works if 1 is not in the set
	then we should keep a method on hand specially for if 1 is in S)

	Basically, think of n as a bunch of ones.
	Take as big of a bite as you can and keep doing that until you cannot bite
	anymore.
	Then go back one step, take one bite smaller and continue onward.
	So for n = 5, S = {3, 2, 1} visualize like this:

	1   1   1 | 1   1
	1   1   1 | 1 | 1
	1   1 | 1   1 | 1
	1   1 | 1 | 1 | 1
	1 | 1 | 1 | 1 | 1

	It is important to note that no bite can be larger than a preceding bite.
	So if the first bite was 2, you cannot bite for more than 2 the rest of the
	iteration (the third row exemplifies this, could not take a bite of 3 after
	first taking a bite of 2).

	Note:
		- for S = [n:1], this makes partitions where order of partition
		  does not matter.

	TODO MAKE THIS AN ITERATOR!
	For the iterator, hold the list of strings in the struct. That will make it
	easy. You're still passing an object each method call though. There would
	probably be MORE overhead this way!

	NOTE NOTE NOTE HOW TO MAKE THIS ITERATOR? THIS IS:
	SLOANE'S A000607
	a(n) = 1/n*Sum_{k=1..n} A008472*a(n-k)
	where A008472 is the sum of the distinct primefactors of k!!
	USE THIS FOR PROBLEM 169 I BET SOMEHOW.
	HAHAHAHHAHAHAHAHAHAHAAHAHHHAHAHHAHHAHAHAHAHAHAA.
	=#

	# sort S but if we know it is in big -> small comment this out for more
	# efficiency.
	sort!(S, rev=true)
	P = String[]
	for k in S
		i = findfirst(x -> x == k, S)
		# why S[i:end]? Bc can't take bigger bite than bite before so those
		# other numbers are irrelevant.
		tP = partitions_of_n_from_set_S_rec(n-k, k, string(k) * " ", S[i:end],String[])
		if length(tP) == 0
			continue
		end
		if length(P) == 0
			P = tP
		else
			P = hcat(P, tP)
		end
	end
	return P
end

function partitions_of_n_from_set_S_rec(n::Int, k::Int, 
											 p::String, S::Array{Int},
										     P::Array{String})
	#=
	n is the number we are splitting
	k is the size of the last bite taken
	p is the string representing the current partition
	S is the set of values that we can draw from (sorted biggest->smallest)
	P list of the partitions.

	returns the list of the partitions..
	=#

	# Take as big as a bite as possible
	#@printf "n = %d \t k = %d \t S = %s \t p = %s\n" n k repr(S) p
	for i in S
		# don't take too big of a bite
		if n - i < 0
			continue
		elseif n - i == 0
			t = p * string(i) * " "
			if length(P) == 0
				P = [t]
			elseif !(t in P)
				P = hcat(P, t)
			end

			# Can you keep splitting up this bite? Do it.
			index = findfirst(x -> x == i, S)
			if index < length(S)
				P = partitions_of_n_from_set_S_rec(n-S[index+1], S[index+1],
													p*string(S[index+1])*" ",
													S[index+1:end], P)
			end

		else
			k = findfirst(x -> x == i, S)
			P = partitions_of_n_from_set_S_rec(n-i, i,
												   p * string(i) * " ", S[k:end], P)
		end
	end
	return P
end

#=
function main()
	S = [13, 11, 7, 5, 3, 2]; n = 15
	parts = partitions_of_n_from_set_S(n, S)
	println(parts)
	for part in parts
		println(part)
	end
end

 main()
 =#