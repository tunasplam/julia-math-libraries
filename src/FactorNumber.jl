# everything regarding factoring numbers goes here (DUH)

function prime_factors(n::Int)::Vector{Int}
	#=
	Here is benchmarks comparing this algorithm to an algorithm
	where all of the primes leq n/2 are sieved and then iterated through
	to check for factors

		sieve approach
	Range (min … max):  1.299 ns … 47.750 ns  ┊
	Time  (median):     1.320 ns              ┊
	Time  (mean ± σ):   1.419 ns ±  0.835 ns  ┊

		this approach
	Range (min … max):  1.290 ns … 21.320 ns  ┊
	Time  (median):     1.310 ns              ┊
	Time  (mean ± σ):   1.392 ns ±  0.357 ns  ┊

	=#

	factors = []

	# get the twos first
	if n % 2 == 0
		push!(factors, 2)
	end
	while n % 2 == 0
		n ÷= 2
	end

	# iterate odd numbers and divide them out if they divide cleanly.
	# you will never get a composite this way.
	limit = floor(Int, sqrt(n))
	# TODO should limit restrict here?
	for i in 3:2:limit
		if n % i == 0
			push!(factors, i)
		end
		while n % i == 0
			n ÷= i
		end
	end

	# if n > 2 then it has been reduced to its final prime factor
	if n > 2
		push!(factors, n)
	end
	return factors
end

function prime_factorization(n::Int)::Vector{Tuple{Int,Int}}
	#=
	NOTE wheel factorization for taking out the 2's 3's and 5's
	looks to be slower than this. but there is an interesting implementation
	where we precompute primes up to a certain amount (10^8 should be fine),
	have them stored as a lookup table. Then, we only check primes up to 
	sqrt(n)
	=#

	# this uses wheel factorization
	# get the twos first
	power, factorization = 0, []
	while n % 2 == 0
		power += 1
		n ÷= 2
	end
	if power > 0
		push!(factorization, (2, power))
	end

	limit = floor(Int, n^(0.5))
	for i in 3:2:limit
		power = 0
		while n % i == 0
			power += 1
			n ÷= i
		end
		if power > 0
			push!(factorization, (i, power))
		end
	end

	if n > 2
		push!(factorization, (n, 1))
	end
	return factorization
end

function radical(n::Int)::Int
#=
	The product of the distinct prime factors of n.
	note that squarefree integers are equal to their radical (pretty self evident)
	So if we can figure out mobius function that might help us here.

	multiplicative with rad(p^a) = p
=#
	p_fact = list_prime_divisors(n)
	rad = 1
	for p in p_fact
		rad *= p
	end
	return rad
end

function radical_list(n::Int)::Vector{Int}
	#=
	finds rad(n) for 1:n
	=#
	result = [radical(i) for i in 1:n]
	return result
end

@inline function f(x::Integer, c::Integer, m::Integer)::Integer
	return (x*x % m) + c % m
end

function rho(n::Integer, x0::Integer, c::Integer=1)::Integer
	#= Uses pollard rho to find a factor of n
	https://cp-algorithms.com/algebra/factorization.html

	The idea is that we are trying to find a cycle in the IFS
	(x^2 + c) % n for fixed c (that looks familiar!)
	if we find x_s and x_t s.t. gcd(x_s - x_t, n) > 1,
		then we have a cycle and the gcd is the factor.

	we use tortoise and hare to do so

	=#
	x = x0
	y = x0
	g = 1
	while g == 1
		x = f(x, c, n)
		y = f(y, c, n)
		y = f(y, c, n)
		g = gcd(abs(x - y), n)
	end
	return g
end

function prime_factors_prho(n::Integer, max_prho_trials::Int=40)::Vector{Integer}
    # think of this in terms of factor trees. keep knocking down
    # divisors until all results are prime. this is your pfact.
    # this only returns prime factors and not powers.
    # TODO there are some obvious speed ups here that could arise
    # from making this recursive.
	# TODO tune this a bit more and then make this the default prime_factors

    pfs = Vector{Integer}()

    # TODO should tune is_prime to choose the best fitting algorithm
    if miller_rabin(n)
        push!(pfs, n)
        return pfs
    end

    # start with trial division pf primes up to trial div limit
    # if sqrt(n) < 1000, then just use trial division for whole process
    trial_div_limit = min(floor(Int, sqrt(n)), 1000)
    ps = J.primes_leq(trial_div_limit)
    for p in ps
        if n % p == 0
            push!(pfs, p)
            # take out all factors. NOTE at this point if you want p powers then
            # determine that here.
            while n % p == 0; n ÷= p; end
            if n == 1
                return pfs
            end
            if is_prime(n)
                return push!(pfs, n)
            end
        end
    end

    # here is where we finish the process off with prho if needbe
    # number of prho trials should be like 40 or so
    for c in Random.shuffle(ps[1:max_prho_trials÷2])
        r = rho(n, rand(1:n), c)
        if is_prime(r) && r ∉ pfs
            push!(pfs, r)
            while n % r == 0; n ÷= r; end
            if n == 1
                return pfs
            end
            if is_prime(n)
                return sort!(push!(pfs, n))
            end
        end
    end
    println("Warning: may not have fully factored.")
    return sort!(pfs)
end