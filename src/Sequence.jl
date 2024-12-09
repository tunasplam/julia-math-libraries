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
