# What is the smallest number divisible by EACH of the numbers 1 .. k ?

# explanation in pdf overview for problem 5

# Need an array of primes up to k

function main(k)

	N, i = 1, 1
	check = true
	limit = k^(0.5)
	# beautiful one liner to get a list of all primes from 1:k
	# basically, p is a list of num such that num is prime. Check for range 1:some number
	primes = [2,3,5,7]
	append!(primes, filter( num->prime(num), [i for i in 11:k*100] ))
	println(primes)
	while primes[i] <= k
		prime_power = 1
		if check
			if primes[i] <= limit
				prime_power = floor( log10(k) / log10(primes[i]) )
			else
				check = false
			end
		end
		N = N * primes[i] ^ prime_power
		println(primes[i], " ^ ", prime_power)
		i += 1
	end
	return N
end

# determine whether or not a number is prime.
function prime(n)
	if n % 2 == 0
		return false
	elseif n % 3 == 0
		return false
	else
		r = floor(n^(0.5))
		f = 5
		while f <= r
			if n % f == 0
				return false
			end
			if n % (f + 2) == 0
				return false
			end
			f += 6
		end
		return true
	end
end

println(main(20))
