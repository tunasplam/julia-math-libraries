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
    if n == 1
		return collect(Set(seed))
	end

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
	return return collect(Set(Iterators.flatten((l, m, r) for (l, m, r) in processed)))
end

function farey_sequence(n::Int, a::Rational=0//1, b::Rational=1//1)::Vector{Rational}
    #=
    Use a farey sequence to generate a list of rational numbers of the form a/b
    where HCF(a,b) = 1 and b <= n
    =#
    @assert n > 0

    # start off with the first two terms of the sequence
    s = [a, rational_number_to_right_of(a, n)]
    # recurrence relation helps us figure out the rest
    while s[end] != b
        p, q = s[end-1], s[end]
        d = floor((p.den + n)/q.den)
        push!(s, (Int(round(d*q.num)) - p.num) // (Int(round(d*q.den)) - p.den))
    end
    return s
end

#=
for integer a_0 ∈ [0, 2^48),
	a_n = (25214903917 * a_{n-1} + 11) % 2^48
=#
struct Rand48
	seed::Int # a_0
	max::Int # how far to generate
end

# returns a_{n+1}
function Base.iterate(iter::Rand48, state=(iter.seed, 0))
	a_n, count = state
	count > iter.max ? nothing : (a_n, ((BigInt(25214903917) * a_n + 11) % 2^48, count + 1))
end

Base.IteratorSize(::Type{Rand48}) = Base.HasLength()
Base.length(iter::Rand48) = iter.max

function alternating_sum(a::Vector{Int}, start_negative::Bool=false)::Integer
	#=return alternating sum of a given integer sequence.
	set start_negative to true if you want to start with -1.
	=#
	# sum the even and the odd indexed values
	# then add or subtract based on start_negative
	return start_negative ? sum(a[2:2:end]) - sum(a[1:2:end]) : sum(a[1:2:end]) - sum(a[2:2:end])
end

function partial_sum(a::Vector{Integer})::Vector{Integer}
	for i in 2:length(a)
		a[i] = a[i-1] + a[i]
	end
	return a
end
