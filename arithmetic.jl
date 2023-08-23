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

function bin_exp_mod_m(a, b, m)
    a %= m
    res = 1
    while (b > 0)
        if (b & 1)
            res = res * a % m
        end
        a = a * a % m
        b >>= 1
    end
    return res
end


if abspath(PROGRAM_FILE) == @__FILE__
    @time a = bin_exp_test
    @time b = bin_exp
    print(a == b)
end