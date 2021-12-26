#=
	All things pascal's triangle
=#

#=
	This iterator does things by looking at the half triangle.
=#
mutable struct Pascals_Triangle{T<:Integer}
	num_rows::Int
	prev_row::Array{T}
end

pascals_triangle(n::Integer) = Pascals_Triangle(n, [1])
pascals_triangle(n::Integer, T::Type) = Pascals_Triangle{T}(n, [1])

# TODO how are bigs handled here?
function Base.getindex(PT::Pascals_Triangle, n::Int)
	0 <= n <= PT.num_rows || throw(BoundsError(PT, n))
	row = zeros(n+1)
	for i in 0:(n+1)÷2
		t = binomial(n, i)
		println(t)
		row[i+1] = t
		row[n-i-1] = t
	end
	# if we got an odd row number now need to figure out the entry
	# in the middle.
	row[(n÷2)+2] = binomial(n, (n÷2)+1)
	return row
end

function generate_pascals_triangle(n)
	# generates line by line.
	triangle = []
	last_line, new_line = [1, 1], [1]
	line_num = 3
	for line in 1:n-2
		for index in 2:line_num-1
			append!(new_line, last_line[index-1]+last_line[index])
		end
		append!(new_line, 1)
		last_line = new_line
		new_line = [1]
		line_num += 1
		append!(triangle, [last_line])

	end
	return triangle
end

function generate_pascals_triangle_mod_k(n, k)
	# generates line by line.
	triangle = []
	last_line, new_line = [1, 1], [1]
	line_num = 3
	for line in 1:n-2
		for index in 2:line_num-1
			append!(new_line, last_line[index-1]+last_line[index])
		end
		append!(new_line, 1)
		new_line = [x % k for x in new_line]
		last_line = new_line
		new_line = [1]
		line_num += 1
		append!(triangle, [last_line])

	end
	return triangle
end

function generate_half_pascals_triangle(n)
	# generates line by line.
	# But split down the middle so just the unique entries.
	triangle = []
	last_line, new_line = [1, 1], [1]
	line_num = 3
	for line in 1:n-2
		bound = bound = line_num÷2

		for index in 2:bound
			append!(new_line, last_line[index-1]+last_line[index])
		end

		if line_num % 2 == 1
			append!(new_line, 2*last_line[(line_num-1)÷2])
		end

		last_line = new_line
		new_line = [1]
		line_num += 1
		append!(triangle, [last_line])

	end
	return triangle
end

function generate_half_pascals_triangle_mod_k(n, k)
	# generates line by line.
	# But split down the middle so just the unique entries.
	triangle = []
	last_line, new_line = [1, 1], [1]
	line_num = 3
	for line in 1:n-2
		bound = bound = line_num÷2

		for index in 2:bound
			append!(new_line, last_line[index-1]+last_line[index])
		end

		if line_num % 2 == 1
			append!(new_line, 2*last_line[(line_num-1)÷2])
		end

		new_line = [x % k for x in new_line]
		last_line = new_line
		new_line = [1]
		line_num += 1
		append!(triangle, [last_line])

	end
	return triangle
end

function main()
	pt = pascals_triangle(10)
	println(pt[5])
end

main()