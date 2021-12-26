#=
	Miscellaneous Number Theoretic sequences

	- Hamming (5-smooth) numbers
	- Triangular numbers (both given term and iterator)
=#

include("./primes_list.jl")
include("./factor_number.jl")
using Printf

function main()
	for i in Triangular_Numbers(10)
		println(i)
	end
end

#=
	Triangular Numbers
	Starts at TN(0) = 0, TN(1) = 1, TN(2) = 3, ...
=#
mutable struct Triangular_Numbers{T<:Integer}
	# nth term.
	n::Int
	prev_term::T
end
Triangular_Numbers(n::Integer) = Triangular_Numbers(n, 0)
Triangular_Numbers(n::Integer, T::Type) = Triangular_Numbers{T}(n, 0)

#=
	Lets us use formula to grab nth term using indexing.
=#
function Base.getindex(TN::Triangular_Numbers, n::Int)
	0 <= n <= TN.count || throw(BoundsError(TN, n))
	return n*(n+1)÷2
end

Base.length(TN::Triangular_Numbers) = TN.n
Base.firstindex(TN::Triangular_Numbers) = 1
Base.lastindex(TN::Triangular_Numbers) = length(TN)
Base.getindex(TN::Triangular_Numbers, i::Number) = TN[convert(Int, i)]
Base.getindex(TN::Triangular_Numbers, I) = [TN[i] for i in I]

function Base.iterate(TN::Triangular_Numbers, state=0)
	if state == 0
		(0, 1)
	elseif state > TN.n
		nothing
	else
		TN.prev_term = TN.prev_term + state
		(TN.prev_term, state + 1)
	end
end

#=
	End Triangular Numbers
	Begin Pentagonal Numbers
	TODO No iterating these?
=#

mutable struct Pentagonal_Numbers{T<:Integer}
	# nth term.
	n::Int
	prev_term::T
end
Pentagonal_Numbers(n::Integer) = Pentagonal_Numbers(n, 0)
Pentagonal_Numbers(n::Integer, T::Type) = Pentagonal_Numbers{T}(n, 0)

function Base.getindex(PN::Pentagonal_Numbers, n::Int)
	0 <= n <= PN.count || throw(BoundsError(PN, n))
	return n*(3*n-1)÷2
end

Base.length(PN::Pentagonal_Numbers) = PN.n
Base.firstindex(PN::Pentagonal_Numbers) = 1
Base.lastindex(PN::Pentagonal_Numbers) = length(PN)
Base.getindex(PN::Pentagonal_Numbers, i::Number) = PN[convert(Int, i)]
Base.getindex(PN::Pentagonal_Numbers, I) = [PN[i] for i in I]

#=
	End Pentagonal Numbers
	HAMMING NUMBERS THERES A LOT HERE.
=#
function hamming_numbers_list_rec(n::Integer; s::Integer=1)
	#=
	Okay... so split n up into halves until you can't split it anymore.
	Then brute force the hamming numbers up to that value.
	Then keep returning and doubling with the multiplying everything by
	2, 3, and 5.
	Keep splitting it up until n/s < 10^5
	At that point, splitting it up further will not yield significant
	performance increase.

	Incredibly faster. Might even be better than the log2 improvement
	that we previously anticipated.
	TODO need to check if these values are right though somehow...
	TODO overflow will happen eventually.
	=#
	if n/s < 10^5
		# Brute force the small bit. Then return the results.
		# the previous iteration will take that, double it, and return it.
		# the next iteration will take that, double it, and return it.
		# etc.
		#println(n, " ", s)
		return hamming_numbers_brute_force(n÷s)
	else
		# s=s*2 bc we are doubling the amount that we are cutting out.
		h_numbers = hamming_numbers_list_rec(n, s=s*2)
	end

	# NOTE INSTEAD OF GOING TO n GO TO n/s
	# if we have gotten here then we have finished descending the recursive
	# staircase and have start going upwards.. double and return.
	# Note that this iterative approach is marginally slower than the filter
	# approach BUT can easily be expended to generalized hamming numbers.
	result = vcat(h_numbers, 2*filter(x-> x>h_numbers[end] ÷ 2, h_numbers))
	primes = [2,3,5]
	for p in primes[2:end]
		p_begin = findfirst(x->x > h_numbers[end] ÷ p, h_numbers)
		p_end = findfirst(x->x > (n/s) ÷ p, h_numbers)
		for num in h_numbers[p_begin:p_end-1] 
			#h_num = true
			#for p2 in primes[1:i-1]
				#if num % p2 == 0
				#	h_num = false
				#	break
				#end
			#end
			#if h_num
			append!(result, p*num)
			#end
		end
	end

	# TODO BANDAGE SOLUTION HERE
	# iterate the perfect powers of 2, 3, and 5 and append them. This only works if
	# we can prove that only powers of 2, 3, and 5 can be numbers that need to be
	# mulitiplied in the alogrithm here which are less than two, three, and five_begin
	for p in [2, 3, 5], k in floor(Int, log(p, (n÷s)))
		if !(p^k in result)
			append!(result, p^k)
		end
	end

	# We had some duplicates. In fact the unique might be so fast that we can ignore
	# filtering out duplicates above...
	return sort(unique(result))
end

function general_hamming_numbers_list(n::Integer, type; s::Integer=1)
	#=
	See the hamming_numbers_list_rec for info

	only difference here is type tells us how high to count up the primes.
	=#
	if n/s < 10^5
		# Brute force the small bit. Then return the results.
		# the previous iteration will take that, double it, and return it.
		# the next iteration will take that, double it, and return it.
		# etc.
		#println(n, " ", s)
		return general_hamming_numbers_brute_force(n÷s, type)
	else
		# s=s*2 bc we are doubling the amount that we are cutting out.
		h_numbers = general_hamming_numbers_list(n, 100, s=s*2)
	end

	# NOTE INSTEAD OF GOING TO n GO TO n/s
	# if we have gotten here then we have finished descending the recursive
	# staircase and have start going upwards.. double and return.
	# Note that this iterative approach is marginally slower than the filter
	# approach BUT can easily be expended to generalized hamming numbers.
	result = vcat(h_numbers, 2*filter(x-> x>h_numbers[end] ÷ 2, h_numbers))
	primes = prime_list_erat(type)
	#println(primes)
	for p in primes[2:end]
		p_begin = findfirst(x->x > h_numbers[end] ÷ p, h_numbers)
		p_end = findfirst(x->x > (n/s) ÷ p, h_numbers)
		for num in h_numbers[p_begin:p_end-1] 
			#h_num = true
			#for p2 in primes[1:i-1]
				#if num % p2 == 0
				#	h_num = false
				#	break
				#end
			#end
			#if h_num
			append!(result, p*num)
			#end
		end
	end

	# TODO BANDAGE SOLUTION HERE
	# iterate the perfect powers of 2, 3, and 5 and append them. This only works if
	# we can prove that only powers of 2, 3, and 5 can be numbers that need to be
	# mulitiplied in the alogrithm here which are less than two, three, and five_begin
	for p in [2, 3, 5], k in floor(Int, log(p, (n÷s)))
		if !(p^k in result)
			append!(result, p^k)
		end
	end

	# We had some duplicates. In fact the unique might be so fast that we can ignore
	# filtering out duplicates above...
	return sort(unique(result))
end

function general_hamming_numbers_brute_force(n::Int, type::Int)
	h_numbers = trues(n)
	primes = prime_list_erat(n)

	# differnece for general. Start filtering out primes bigger
	# than the type.
	start_index = findfirst(x->x>type, primes)

	# now find the real h_numbers by looking at primes bigger than p.
	# true_h_numbers = trues(length(h_numbers))
	for p in primes[start_index:end]
		# how big can we make k s.t. p*k <= n
		k_lim = floor(Int, n/p)
		for k in 1:k_lim
			h_numbers[p*k] = 0
		end
	end
	h_numbers = findall(x->x==1, h_numbers)
	return h_numbers
end

function hamming_numbers_brute_force(n::Int)
	h_numbers = trues(n)
	primes = prime_list_erat(n)

	# now find the real h_numbers by looking at primes bigger than p.
	# true_h_numbers = trues(length(h_numbers))
	for p in primes[4:end]
		# how big can we make k s.t. p*k <= n
		k_lim = floor(Int, n/p)
		for k in 1:k_lim
			h_numbers[p*k] = 0
		end
	end
	h_numbers = findall(x->x==1, h_numbers)
	return h_numbers
end

function hamming_numbers_list(n)
	#=
	OLD SEE THE RECURSIVE ITS MUCH BETTER.
	list out all the hamming (5-smooth) numbers up to a value n.

	uses a sieve.

	Generate the primes up to n. Look at all the primes between 5 and n
	and strike out their multiples that are less than n.

	Resulting numbers should be hamming numbers.

	A051037

	10^7 ~ 3s 768 totals h_numbers
	missing one but the n/2 trick cut the generation time in HALF.
	keep doing the halving trick and it should be log2 faster i would think.

	idea: generate the hamming numbers up to n/2. then, multiply these
	numbers by 2, 3, and 5 to get the second half of the hamming numbers
	list. Will need to make sure to only multiply up to n/p for each p we
	are looking at. but need at least n/2 vlaues generated.

	Can make this like a binary search i guess. Keep splitting down n by halves.
	Bruteforce generate only like 1:n/32. Then just keep doing the doubling
	algorithm.
	=#

	# First, hamming numbers up to n/2
	# makes a bit array with all false values.
	h_numbers = trues(n÷2)
	primes = prime_list_erat(n÷2)

	# now find the real h_numbers by looking at primes bigger than p.
	# true_h_numbers = trues(length(h_numbers))
	for p in primes[4:end]
		# how big can we make k s.t. p*k <= n
		k_lim = floor(Int, n/(2*p))
		for k in 1:k_lim
			h_numbers[p*k] = 0
		end
	end
	h_numbers = findall(x->x==1, h_numbers)
	
	# Note that this iterative approach is marginally slower than the filter
	# approach BUT can easily be expended to generalized hamming numbers.
	result = vcat(h_numbers, 2*filter(x-> x>h_numbers[end] ÷ 2, h_numbers))
	i = 2; primes = [2,3,5]
	for p in primes[2:end]
		p_begin = findfirst(x->x > h_numbers[end] ÷ p, h_numbers)
		p_end = findfirst(x->x > n ÷ p, h_numbers)
		for num in h_numbers[p_begin:p_end-1] 
			#h_num = true
			#for p2 in primes[1:i-1]
				#if num % p2 == 0
				#	h_num = false
				#	break
				#end
			#end
			#if h_num
			append!(result, p*num)
			#end
		end
		i += 1
	end

	# TODO BANDAGE SOLUTION HERE
	# iterate the perfect powers of 2, 3, and 5 and append them. This only works if
	# we can prove that only powers of 2, 3, and 5 can be numbers that need to be
	# mulitiplied in the alogrithm here which are less than two, three, and five_begin
	for p in [2, 3, 5], k in floor(Int, log(p, n))
		if !(p^k in result)
			append!(result, p^k)
		end
	end

	return unique(result)
end

function hamming_numbers_list_filter_so_its_faster_but_cant_really_be_generalized(n)
	#=
	list out all the hamming (5-smooth) numbers up to a value n.

	uses a sieve.

	Generate the primes up to n. Look at all the primes between 5 and n
	and strike out their multiples that are less than n.

	Resulting numbers should be hamming numbers.

	A051037

	10^7 ~ 3s 768 totals h_numbers
	missing one but the n/2 trick cut the generation time in HALF.
	keep doing the halving trick and it should be log2 faster i would think.

	idea: generate the hamming numbers up to n/2. then, multiply these
	numbers by 2, 3, and 5 to get the second half of the hamming numbers
	list. Will need to make sure to only multiply up to n/p for each p we
	are looking at. but need at least n/2 vlaues generated.

	Can make this like a binary search i guess. Keep splitting down n by halves.
	Bruteforce generate only like 1:n/32. Then just keep doing the doubling
	algorithm.
	=#

	# First, hamming numbers up to n/2
	# makes a bit array with all false values.
	h_numbers = trues(n÷2)
	primes = prime_list_erat(n÷2)

	# now find the real h_numbers by looking at primes bigger than p.
	# true_h_numbers = trues(length(h_numbers))
	for p in primes[4:end]
		# how big can we make k s.t. p*k <= n
		k_lim = floor(Int, n/(2*p))
		for k in 1:k_lim
			h_numbers[p*k] = 0
		end
	end
	h_numbers = findall(x->x==1, h_numbers)

	# Now, multiply all elements by 2, then 3, then 5 but only as far
	# where to start looking for multiples of 2
	two_begin = h_numbers[end] ÷ 2
	three_begin = h_numbers[end] ÷ 3
	five_begin = h_numbers[end] ÷ 5

	result = vcat(h_numbers, 2*filter(x-> x>two_begin, h_numbers))
	result = vcat(result, 3*(filter(x-> x>three_begin && x<=n÷3 && x%2==1, h_numbers)))
	# TODO should be x%3 != 0 instead!!! Why was that not a problem?
	result = vcat(result, 5*(filter(x-> x>five_begin && x<=n÷5 && x%2==1 && x%3==1, h_numbers)))
	# TODO BANDAGE SOLUTION HERE
	# iterate the perfect powers of 2, 3, and 5 and append them. This only works if
	# we can prove that only powers of 2, 3, and 5 can be numbers that need to be
	# mulitiplied in the alogrithm here which are less than two, three, and five_begin
	for p in [2, 3, 5], k in floor(Int, log(p, n))
		if !(p^k in result)
			append!(result, p^k)
		end
	end

	return result
end

#=
	END HAMMING NUMBERS
=#

main()