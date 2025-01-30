#=
Where things get played around with before getting solidified
=#

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

@show stern_brocot_tree(3, (1//3, 2//5, 1//2))
