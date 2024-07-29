function bin_exp_test()
    x = 0
    for i in 1:10^5
        for j in 1:10^5
            x += bin_exp(i, j)
        end
    end
    return x
end

function regular_exp_test()
    x = 0
    for i in 1:10^5
        for j in 1:10^5
            x += i^j
        end
    end
    return x
end

function bin_exp(a, b)
    # NOTE this is actually SLOWER than the ^ operator.
    #=
    Instead of doing 2^10 = 2 * 2 * ... * 2 (10 times)
    do 2^10 = 2^8 * 2^2 = (2^2)^4 * 2^2
    =#
    res = 1
    while (b > 0)
        if (b & 1 == 1)
            res = res * a
        end
        a = a * a
        b >>= 1
    end
    return res
end

function bin_pow_mod_m(a, b, m)
    # TODO huge speed up for m prime
    # See this note for speed up for m prime
    # https://cp-algorithms.com/algebra/binary-exp.html#effective-computation-of-large-exponents-modulo-a-number
    a %= m
    res = 1
    while b > 0
        if b & 1 == 1
            res = res * a % m
        end
        a = a * a % m
        b >>= 1
    end
    return res
end

function tetration(a, b, m)
    #=
        a ^^ b % m
        a ^^ b =
            1               if b = 0
            a^(a ^^ (b-1))  if b > 0 
    
        where f is some nested function such as 2x
    =#
    if b == 0
        return 1
    else
        # its the repeated exponentiation. it may seem weird that the nested
        # call here is tetration but remember that tetration is returning
        # repeated exponentiation
        # @printf "\t %s %s\n" a b
        return bin_pow_mod_m(a, tetration(a, b-1, m), m)
    end
end

function pentation(a, b, m)
    #=
        a ^^^ b % m
        a ^^^ b % m =
            1                if b = 0
            a ^^ ( a ^^^ b-1) if b > 0
    =#
    if b == 0
        return 1
    else
        # repeated tetration which might seem weird that the nested call
        # here is pentation but remember that pentation is returning
        # repeated tetration
        # @printf "%s %s\n" a b
        return tetration(a, pentation(a, b-1, m), m)
    end
end


if abspath(PROGRAM_FILE) == @__FILE__
    println(tetration(2, 2, 14^8))
end