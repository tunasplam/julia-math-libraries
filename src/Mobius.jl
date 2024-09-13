using Pipe
using Memoize

function μ_leq(n::Int)::Vector{Int}
	#=
	Generate first n entries of mobius list as quickly as possible.
	A few things to note:
	- it is multiplicative.
	- If mu(n) == 1 || -1, then all multiples of n = 0

	Try list and dict and see what is better. Need 5493321 entries at least.
	=#
	results = [2 for i in 1:n]
	results[1] = 1
	for num in 2:n
		if results[num] == 2
			res = μ(num)
			results[num] = res
			# TODO faster to do integer division?
			for k in 2:floor(Int, log(num, n))
				results[num^k] = 0
			end
		end
	end
	return results
end

function μ(n)
	#=
	https://en.wikipedia.org/wiki/M%C3%B6bius_function#:~:text=The%20M%C3%B6bius%20function%20is%20multiplicative,a%20and%20b%20are%20coprime.&text=The%20equality%20above%20leads%20to,of%20multiplicative%20and%20arithmetic%20functions.
	see properties heading
	=#

	#=
	total = 0
	for k in 1:n
		if gcd(k, n) == 1
			# Using euler's formula and noting that we only care about
			# the real part.
			total += cos(2π*(k/n))
		end
	end
	return(round(Int, total))
	=#

	return @pipe 1:n |>
		filter(k -> gcd(k, n) == 1, _) |>
		map(k -> cos(2π*(k/n)), _) |>
		sum |>
		round(Integer, _)

end

@memoize function not_as_good_mobius(n::Integer)::Integer
	#=	Slower at both individual computation as well as list
		generation than the current implementation of μ.

		See the "Sage" implementation of A008683.
		An incredibly beautiful recursive solution.
		Slightly slower than the other mobius function though.
	=#
	if n < 1
		throw(DomainError)
	elseif n == 1
		return 1
	end
	return -sum(map(μ, proper_divisors(n)))
end

#=
	Square free numbers specific stuff below.
	Maybe one day it will be its own file.
=#
function count_squarefree_numbers_lt(n::Integer)::Integer
	# A013928
	# we want to put as restrictive of a cap on the largest value
	# of μ needed as possible.
	
	if n < 1
		throw(DomainError)
	elseif n == 1
		return 0
	end

	# here are some options to benchmark
	# passing
	return sum([μ(d) * floor(Int, (n-1)/d^2) for d in 1:floor(Int, sqrt(n-1))])
	# NOTE this one is not passing tests and i wonder if the formula itself
	# is suspicious
	#return sum([μ(k) * floor(Int, n/k^2) for k in 1:floor(Int, sqrt(n))])

end

function count_squarefree_numbers_lt_old(n::Integer)::Integer
    #=
    Incredibly beautiful implementation of A013928.
    It is, however, ridiculously slow and space intensive. It involves
    nxn matricies soooooo.... yeah.

	This absolutely has to be implemented using the mobius function.
    =#

    if n < 1
        throw(DomainError)
	elseif n == 1
        return 0
    end

    # define n x n (0, 1) matrix A by A[i, j] = 1 if gcd(i, j) = 1
    A = reduce(hcat, _generate_rows(n, k) for k in 1:n-1)
    # NOTE that this a symmetric matrix, so we can employ a specialized instance of Matrix
    A = Symmetric(A)

    # the rank of A is a(n + 1). MINDBLOWING.
    return rank(A)

end

function _generate_rows(n::Integer, k::Integer)::Vector{Integer}
    # generate the kth row of the nxn matrix A
    return [gcd(k, i) == 1 ? 1 : 0 for i in 1:n-1]
end

# without using symmetric matrix
# @benchmark count_squarefree_numbers_lt setup=(x=rand(Int,2^10))
#=
BenchmarkTools.Trial: 10000 samples with 1000 evaluations.
 Range (min … max):  1.290 ns … 45.710 ns  ┊ GC (min … max): 0.00% … 0.00%
 Time  (median):     1.450 ns              ┊ GC (median):    0.00%
 Time  (mean ± σ):   1.484 ns ±  0.658 ns  ┊ GC (mean ± σ):  0.00% ± 0.00%

  ▅▂          ▃█▅            ▂▄              ▂               ▁
  ██▁▁▄▁▁▁▁▁▁▁███▁▃▁▃▃▃▁▄▁▄▅▄██▅▅▄▅▅▃▅▃▅▆▆▇▇▃█▁▃▅▄▅▄▅▄▄▆▅▄▆▇ █
  1.29 ns      Histogram: log(frequency) by time     1.99 ns <

=#

# with using symmetric matrix
# @benchmark count_squarefree_numbers_lt setup=(x=rand(Int,2^10))
#=
BenchmarkTools.Trial: 10000 samples with 1000 evaluations.
 Range (min … max):  1.290 ns … 19.620 ns  ┊ GC (min … max): 0.00% … 0.00%
 Time  (median):     1.300 ns              ┊ GC (median):    0.00%
 Time  (mean ± σ):   1.324 ns ±  0.283 ns  ┊ GC (mean ± σ):  0.00% ± 0.00%

   █▇▁               ▃                     ▁                 ▁
  ▇████▁▄▃▄▃▁▁▁▃▃▃▁▁▇██▄▄▁▃▃▃▃▃▁▃▃▄▅▁▃▄▁▁▆▁█▆▃▃▁▁▁▁▁▃▁▁▃▄▄▅▅ █
  1.29 ns      Histogram: log(frequency) by time     1.77 ns <

 Memory estimate: 0 bytes, allocs estimate: 0.
=#
