using Pipe
using Memoize

function μ_leq(n::Int)::Vector{Int}
	#=
	Generate first n entries of mobius list as quickly as possible.
			| 0 if n has one or more repeated prime factors
			|		(is not squarefree)
	μ(n) = <  1 if n = 1
			| (-1)^k if n is a product of k distinct primes
			|		(is square free)

	Note that |μ(n)| = | 1 if n is squarefree
					   | 0 otherwise

	A few things to note:
	- it is multiplicative.
	- If mu(n) == 1 || -1, then all multiples of n = 0

	Try list and dict and see what is better. Need 5493321 entries at least.
	=#
	#=
	Here is a brute force algorithm
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
	=#

	# 2.2 from https://smsxgz.github.io/post/pe/counting_square_free_numbers/
	# the idea here is to calculate the mobius value as you are calculating
	# a list of primes
	primes = ones(Int,n)
	μ_list = ones(Int,n)

	for i in 2:n
		# if this value is 0, then we have proven that
		# it is not prime. in this algorithm, we are only
		# operating with the primes.
		if primes[i] == 0
			continue
		end

		μ_list[i] = -1
		for j in 2:n÷i
			# sets all multiples of i as composite 
			primes[i*j] = 0
			#=
			This flips the signs of every multiple of i.
			this is because those numbers are now being
			multiplied by a new distinct prime. if they are
			already proven to not be squarefree, then 0 * -1 = 0
			so it has no effect.
			=#
			μ_list[i*j] *= -1
		end

		for j in 1:n÷(i*i)
			#=
			the square of this new prime factor i times all values j
			s.t. j * i^2 < n is now proven to not be squarefree.
			=#
			μ_list[j*i^2] = 0
		end
	end
	return μ_list

	# BASELINE
	# @time u = [μ(i) for i in 1:10^4]
	# 0.043352 s

	# @time μ_leq(10^5) = 0.043492 s
	# @time μ_leq(10^7) = 0.427699 s
	# we run out of RAM at this point
	# @time μ_leq(10^9) = 
	
	# @benchmark μ_leq(x=rand(Int,10^5))

end

@memoize function μ(n::Integer)::Integer
	#=
	https://en.wikipedia.org/wiki/M%C3%B6bius_function#:~:text=The%20M%C3%B6bius%20function%20is%20multiplicative,a%20and%20b%20are%20coprime.&text=The%20equality%20above%20leads%20to,of%20multiplicative%20and%20arithmetic%20functions.
	see properties heading
	=#
	return @pipe 1:n |>
		filter(k -> Base.gcd(k, n) == 1, _) |>
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
	
	#=
		We need all μs up to sqrt(n) so we cache them
		here since it is more efficient to calculate
		the list via seive than it is to indivudally calc
		the values of μ.
	=#
	μs = μ_leq(floor(Int, sqrt(n)))

	if n < 1
		throw(DomainError)
	elseif n == 1
		return 0
	end

	# here are some options to benchmark
	# passing
	#return sum([μ(d) * floor(Int, (n-1)/d^2) for d in 1:floor(Int, sqrt(n-1))])
	
	#=
	NOTE NOTE NOTE it appears the two sources on the internet are incorrect
	notice that we are multiplying μ by (n-1) instead of n.

	This gets us to 2^30 in 23.2s

	We need μ to be faster
	=#

	s = 0
	@fastmath for d in 1:floor(Int, sqrt(n))
		@fastmath s += μs[d] * (n-1)÷d^2
	end
	return s
	#return sum([μ(k) * floor(Int, (n-1)/k^2) for k in 1:floor(Int, sqrt(n))])

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
