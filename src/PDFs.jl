#=
    Assorted goodies related to probability distributions
=#

function hypergeometric(N::Int, M::Int, n::Int, x::Int)
    #=
        Situation when you want to use this:
            N values
            M of class 1
            N - M of class 2
            n <= N samples
            Sampling without replacement
        
        P(X = x) = Probability of x outcomes of class 1 in n samples
    =#
    return (binomial(M, x) * binomial(N-M, n-x))/binomial(N, n)
end

function poisson(λ::Float64, x::Int)
    #=
        Situation when you want to use this:
            n trials (large number of n)
            probability Θ = λ/n
        To use this, first you need to solve for λ in the equation above
        using the probability of the event occuring and the number of trials.
    =#
    return ((λ^x)/factorial_mod(x, 10^6))*ℯ^((-1)*λ)
end

function negative_binomial(θ::Float64, r::Int, x::Int)
    #=
        Situation when you want to use this:
            for n indepedent trials with binary outcomes,
            this determines the probability that x successes occur
            before the rth failure.
    =#
    return binomial(r-1+k, k)*(θ^r)*(1-θ)^k
end

function binomial_pdf(θ::Float64, n::Int, x::Int)
    #=
        Situation when you want to use this
            n independent trials of probability Θ
            and you want to know the probability of x successes
    =#
    return binomial(n, x)*(θ^x)*(1-θ)^(n-x)
end

function geometric(θ::Float64, x::Int)
    #=
        Situation when you want to use this
            binary event with probability Θ
            probability of x failures before the 1st success
    =#
    return (1-θ)^k*θ
end
