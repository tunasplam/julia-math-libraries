#=
	Random crap regarding sequences.


=#

using Combinatorics

# function main()
# 	test = [3, 1, 1, 3, 3, 1, 1, 3, 3, 1]
# 	println(check_sequence_for_cycle(test))
# end

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

function check_sequence_for_cycle(seq)
	#=
	Given a certain sequence, check if there is a cycle in it.
	Returns the cycle.
	=#
	
	# Create the candidate subsequence entry by entry.
	# If a newly encountered entry is the 1st entry of the candidate,
	# then start adding to another candidate. Keep adding to the second
	# until:
	# 1). An entry in c2 differs from c1. In this case add on c2 to c1
	#	  and continue onwards with c1.
	# 2). c1 = c2, in which case this could likely be the cycle. Check if
	# it holds for the rest of the sequence and, if not,
	# come back to this spot, concat c1 and c2 (BUT NOT THE VALUE WE WERE LOOKING AT)
	# , and continue from the top WITH THE VALUE THAT WE WERE LOOKING AT.

	# TODO do stress tests to optimize the crap outta this.
	c1 = [seq[1]]; c2 = []
	possible_flag = false
	for value in seq[2:end]
		#println(c1, " ", c2, " ", value)
		# This is for if we are checking a potential sequence..
		if possible_flag
			#println(c1, " ", c2)
			tempc2 = vcat(c2, [value])
			# check if c2 differs from c1 at this point.
			# if so, concatenate and continue on using c1.
			if length(tempc2) > length(c1) || tempc2 != c1[1:length(tempc2)]
				possible_flag = false
				c1 = vcat(c1, c2)
				c2 = []
				#println("!", c1)
			end
			append!(c2, value)

			# check if c1 and c2 are the same.
			# if so, check if this period holds
			if c1 == c2
				n = 1
				while (n+1)*length(c1) <= length(seq)
					if c1 != seq[n*length(c1)+1:(n+1)*(length(c1))]
						# this candidate is not a cycle.
						possible_flag = false
						c1 = vcat(c1, c2)
						c2 = []
					end
					n += 1
				end
				# check the ending from here.
				if seq[n*length(c1)+1:end] != c1[1:length(seq)-n*length(c1)]
					# yikes, its not a cycle. return false
					return
				end
				# reached this point means we have a cycle c1. return it.
				return c1
			end
		end

		# Why is this no longer an else to the if above? Because if we find that
		# c2 is not a match then we still need to check the value we were looking 
		# at to see if it is the start of a new cycle
		if !possible_flag
			# test value to see if it is the start of the candidate cycle.
			if value == c1[1]
				# Make c2 and check from here.
				c2 = [value]
				possible_flag = true
			else
				append!(c1, value)
			end
		end
	end
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

# main()
