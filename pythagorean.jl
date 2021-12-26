#=
	All things pythagorean theorem.
=#

function generate_primitive_triple(m,n)
	#=
	Generates primitive triples using given values of m and n.
	Need bounds for m and n? Look at your ristrictions.
	For example if the perimeter must be less than k,
	find m in 2m(m + n) < k for n = 0 to get good enough
	estimate of upper bound for m.
	Then, for each value of m, recalculate bound of n.
	Going to be n <= min(m-1, floor(k/(2m) - m))
	Why the min? bc we always want n < m - 1
	else we get the degenerate case of a triangle with
	side length of 0.

	Note that LHS is the perimeter
	simplified.
	
	MAKE SURE TO CHECK THAT m > n!
	=#
	return [m^2 - n^2, 2*m*n, m^2+n^2]

end

function generate_primitive_triples(limit)
	#=
	See p75.jl
	Generate primitive triples up to a perimiter of limit.
	Sieve approach..
	Generate the primitives. Those vlaues of L and their multiples flagged.
	If a value gets flagged a second time, it is nonunique.
	0 -> unflagged
	1 -> unique
	2 -> nonunique

	See note on the primitives function in pythagorean.jl for notes
	on how bounds of m and n derived.
	Okay get better bounds on n.
	For each value of m, recalculate bound of n.
	Going to be n <= min(m, floor(k/(2m) - m))
	Why the min? bc we always want n < m

	Note the degenerate cases of 0 2 2 and 0 8 8 
	furthermore some are rearrangements.
	For instance m = 1 and n = 3 gives 8 6 10
	while m = 1 n = 2 gives 6 8 10
	For degenerate cases, cannot equal n.
	For rearrangements, store copies of each primitive (sorted)
	compare to see if primitive is already stored before progressing.

	PRIMITIVE IF M AND N COPRIME AND NOT BOTH ODD.
	=#
	m_limit = floor(Int, sqrt(limit/2))
	results = zeros(Int, limit)
	for m in 1:m_limit
		n_limit = min(m-1, floor(Int, limit/(2*m)-m))
		for n in 1:n_limit
			# Check to make sure we have primitives.
			if gcd(m,n) > 1
				#println("bailing ", m ," ", n, " ")
				continue
			end
			if n % 2 == 1 && m % 2 == 1
				#println("bailing ", m ," ", n, " ")
				continue
			end
			L = sum(generate_primitive_triple(m,n))
			# Now strike off L and its multiples.
			orig_L = L
			while L <= limit
				if results[L] == 0
					#@printf "%d New triple %d %d %d for m = %d and n = %d\n" L (m^2-n^2) (2*m*n) (m^2+n^2) m n
					results[L] = 1
				elseif results[L] == 1
					#@printf "%d nonunique triple %d %d %d for m = %d and n = %d\n" L (m^2-n^2) (2*m*n) (m^2+n^2) m n
					results[L] = 2
				end
				L += orig_L
			end
		end
	end
end

#=
function generate_triples_m_n_bind_leg(k)
	#=
	Uses the m, n parametization to generate triples
	where the longest LEG is bound by k.
	=##=
	triples = []
	m, n = 1, 1
	while 

end
=#
