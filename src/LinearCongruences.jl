#=
    Anything involving linear equations mod m go here.
=#

function modular_inverse(a::Integer, n::Integer)::Integer
	#=
	Finds the modular inverse using the bezout coefficients which are found
	using the extended euclidean algorithm (see bezout_coefficients in gcd.jl)
	bezout coefficients here referred to as s and t.
	so...
	ns + at = 1 is what we are interested in solving.
	Since we are working mod n, taking mod n of everything takes out the ns term
	Yields,
	at = 1 (mod n) [it drops since it is a multiple of n]
	Thus, t % n is the modular inverse of a mod n
	=#

    # NOTE disable this assertion for considerable speedup if you can guarantee
    # that a and m will always be relatively prime.
    @assert gcd(a, n) == 1

    if a > n
        throw(DomainError)
    end

	# third arg will always be 1 here since we want to solve ns + at = 1)
	res = bezout_coefficients(n, a, true)
	ans = res[2] % n
    # NOTE if you get negative here simply add n back in to bring it into the right
    # range.
    if ans < 0
		return n + ans
	end
	return ans
end

function array_modular_inverse(A::Vector{Int}, m::Int)::Vector{Int}
    #=
    Given an input array, calculate the modular inverse of every entry mod m.
    This is based on an insanely slick algebra trick so look at the link below for
    a very nice and very simple explanation of what is going on here.

    The idea is to calculate the inverse of x_i as :

    1 / x_i = (1 * 1 * 1) / (1 * x_i * 1)
              product of entries before x_i * 1 * product of entries after x_i
          = --------------------------------------------------------------------
              product of entries before x_i * x_i * product of entries after x_i

        = prefix array * suffix array * (product of entries of array)^-1

        We can easily create these three products by looping over the array 3 times.

    https://cp-algorithms.com/algebra/module-inverse.html#finding-the-modular-inverse-for-array-of-numbers-modulo-m
    =#

    # TODO all entries need to be relatively prime to m. disable this assertion
    # for a massive speed gain.
    for a in A
        @assert gcd(a, m) == 1
    end

    n = length(A)

    # return empty set if input array is 0
    if n == 0
        return zeros(Int, 0)
    end

    # compute 'prefix product array'. This is an array that holds the 'prefix
    # product' for every entry x_i in the array.
    B = zeros(Int, n)
    # v holds the product of all entries (mod m) which we will need
    # in the next step
    v = 1
    for i in 1:n
        B[i] = v
        v = v * A[i] % m
    end

    # compute modular inverse for the product of all numbers mod m
    x = bezout_coefficients(v, m, true)[2]
    x = (x % m + m) % m

    # compute the suffix product array which holds the 'suffix product' for
    # every entry x_i in the array.
    for i in n:-1:1
        # remember, B[i] at this point is the prefix product for x_i
        # this is multiplying by modular inverse for product of all entries
        # mod m
        B[i] = x * B[i] % m
        # we then multiply x by x_i, which in essence multiplies the result
        # entry in B[i] by x_i.
        x = x * A[i] % m
    end

    # at this point every entry in the array is the product of the prefix,
    # the suffix, and the modular inverse of the product of all entries,
    # as desired.
    return B
end
