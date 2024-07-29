#=
	Random crap regarding sequences.
=#

using Combinatorics

function k_distinct_subsets(seq, k)
	#=
	Split the sequence into k distinct subsets.
	Gives a big list of them. Actually, lets make an iterator for it.

	=#

	# gonna start out with 2. This uses the indicies of the elements
	# to create the subset.
	# Start out by finding the number of possible subsets.
	# for k = 2...
	# sum_{i=floor(n/2)}^{n} nCi * (n-i)C(n-i)
	n = length(seq)
	total_count = 0
	lim = n÷2
	for i in 1:lim
		total_count += binomial(n, i)
		# Not adding the last part bc will always be 1
	end

	parts = [[1,4], [2,3]]

	result = []
	indicies = collect(1:n)
	for part in parts, num in part
		temp = []
		for i in 1:num
			append!([combinations(indicies, seq[filter(!(x->x in collect(Iterators.flatten(temp))))])], temp)
		end
	end
	#=
	for i in 1:lim
		result = k_distinct_subsets_rec()
	end

	result = []
	indicies = collect(1:n)
	# subsets of size one and four
	for i in 1:n
		println(i, " ", filter(x->x != i, indicies))
		append!(result, [[seq[i], seq[filter(x->x != i, indicies)]]])
	end

	# subsets of size two and three
	for i in combinations(indicies, 2)
		println(i, " ", filter(!(x->x in i), indicies))
		append!(result, [[seq[i], seq[filter(!(x->x in i), indicies)]]])
	end
	=#

	return result
end

function check_sequence_for_cycle(s::Vector, max_n::Integer=120)
	#=
	Given a certain sequence, check if there is a cycle.
	Only consider max cycle length max_n
	Returns the cycle as a list (empty if no cycle)
	=#

	# check if all elements are the same (cycle of 1)
	if all(x->x==s[1],s)
		return [s[1]]
	end

	# generalized check for cycle of size n
	# can never be length of sequence or larger.
	for n in 2:min(length(s)-1,max_n)

		# this is the cycle which we are checking for
		c = s[1:n]
		cycle = true

		# break up sequence into chunks of expected cycle size
		# leaves a leftover portion to deal with later
		# so checking 123412341234 for cycle 4 becomes 1234 1234 1234
		for i in 2:(length(s) ÷ n)
			# if the given chunk does not match expected cycle, bail
			if s[n*(i-1)+1:n*i] != c
				cycle = false
				break
			end
		end

		# now deal with the remainder (if applicable)
		# this is checking a partial cycle
		# but only check if we think we have a cycle up to this point
		if cycle && length(s) % n != 0
			# get the 'tail' of the cycle
			# for example, in 12341234123 for cycle 4 tail is 123
			t = s[length(s) - length(s) % n + 1:length(s)]
			# check if the cycle holds
			cycle = t == c[1:length(t)]
		end

		if cycle
			return c
		end
	end

	return []
end

function subsequences(seq)
	#=
	Find the subsequences of a sequence.
	Note that these are ordered:

	so 1,2,3
	gives
	1, 12, 123, 2, 23, 3

	input should be a list of strings.

	TODO
	result should have length n(n+1)/2
	this might make things more efficient
	=#
	
	# go through each value in seq and add on values and append until
	# you reach the end. Then start with the next value.
	for i in 1:length(seq)
		tstr = seq[i]
		append!(result, [tstr])
		j = 1
		while i + j <= length(seq)
			tstr *= seq[i+j]
			append!(result, [tstr])
			j += 1
		end
	end
	return result
end
