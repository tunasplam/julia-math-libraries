#=
    Anything regarding the analysis of a suence goes here.
    So the generation of specific suences (such as Fibonnaci)
    does NOT belong here.
=#

function subsequences(s)
	#=
    TODO if you are looking for substrings look in the old
    sequence.jl

	Find the subsuences of a sequence.
	Note that these are ordered:

	so [1, 2, 3]
	gives
	[[1], [1, 2], [1, 2, 3], [2], [2, 3], [3]]

	input should be a list of strings.

	result should have length n(n+1)/2
	=#
    result = []

	# go through each value in s and add on values and append until
	# you reach the end. Then start with the next value.
    for i in eachindex(s)
		a = [s[i]]
		append!(result, [deepcopy(a)])
		j = 1
		while i + j <= length(s)
            append!(a, s[i+j])
			append!(result, [deepcopy(a)])
			j += 1
		end
	end
	return result
end

function stern_brocot_tree(
	n::Int,
	seed::Tuple{Rational, Rational, Rational}=(0//1, 1//1, 1//0)
)::Vector{Rational}
	#=
	Generates the first i rows of the Stern Brocot tree, which is
	a binary search tree that can iterate through the rational numbers

    https://en.wikipedia.org/wiki/Stern%E2%80%93Brocot_tree
	=#

    @assert n > 0
    if n == 1 return reduce(union, seed) end

	to_process = Vector{Tuple{Rational, Rational, Rational}}()
    processed = [seed]

	for _ in 1:(n-1)
		to_process = reverse(processed)
		processed = []

		while !isempty(to_process)
			t = pop!(to_process)
            push!(
				processed,
				(t[1], (t[1].num + t[2].num) // (t[1].den + t[2].den), t[2])
			)
			push!(
				processed, 
				(t[2], (t[2].num + t[3].num) // (t[2].den + t[3].den), t[3])
			)
		end
	end
	return reduce(union, processed)
end
