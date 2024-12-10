#=
    Continued fractions are cool. This was a lot of fun.
    We represent them with vectors as such:

    [1 2 3 4] = 1 + 1/(2+1/(3+(1/4)))

    NOTE the first term is the whole part.

    a fun visualization function is the first function you can use here for fun.

    but wait... we can have repeats
    and crazy sequences that prepend repeating sequences.
    so we say

    [ 1 2 3; 4 3]
    
    is a continued fraction that starts with 1 2 3 and ends with a endless
    cycle of 4 and 3. This is said to have an orbit of 2.

    NOTE i want to literally put cf1 = [ 1 2 3; 4 3]
    and have juliamathlibraries understand me.
    This is not possible because it would clash with [ 1 2 ; 3 4 ]
    being a Matrix constructor.

    TODO Float(cf::ContinuedFraction) needs more test coverage
    TODO FLoat(π) and other irrationals
    TODO ContinuedFraction(Float) :)
    TODO whole parts for everything...
    TODO Rational with orbits?
    TODO this needs to be its own package.
    TODO this needs to be prominently displayed.
    TODO professional looking juliadoc
=#

#=
    Continued_Fraction accepts two Vector{Int} args named head and orbit.
    The continued fractions are a subset of the real numbers.
    If the cf is not repeating, then orbit=[] (Default behavior)

    These first three or four... things... comprise the constructor.
=#

# ContinuedFraction accepts two Int Vectors head and orbit
struct ContinuedFraction{T<:Vector{Int}} <: Real
    head::T
    orbit::T

    # this checks to see if the orbit is valid. If it is, it creates the object.
    # otherwise, it throws an error. the orbit is valid if it is empty or does
    # not have a trailing 0.
    ContinuedFraction(head::Vector{Int}, orbit::Vector{Int}) =
        orbit == Vector{Int}() || orbit[end] != 0 ? 
        new{typeof(head)}(head, orbit) :
        throw(ArgumentError(LazyString(
            "invalid continued fraction: cannot have orbit with a trailing 0.")
        )
    )

    # This is the constructor for when we do not have an orbit. it does not
    # need a safety check
    ContinuedFraction(head::Vector{Int}) = ContinuedFraction(head, Vector{Int}())
end

Base.:(==)(cf1::ContinuedFraction, cf2::ContinuedFraction) =
    cf1.head == cf2.head &&
    cf1.orbit == cf2.orbit

function ContinuedFraction(q::Rational)
    #=
        This is the function that i wrote down on that bus ride going
        over the grapevine to disneyland. My first year teaching, on a
        notepad, while everyone else was watching Dumb and Dumber.
        Here is the comment that was originally left:

            # Below all converted from python script for continued fractions written
            # on bus ride to disney land

        This is a lot of fun. Here is the original code:

            ```
                a, b = num, den
                cf = []
                while b != 0
                    # compute quotient and remainder
                    a = Int(num÷den)
                    b = num % den
                    # Append next part to continued fraction.
                    append!(cf, a)
                    # Shift over values for next iteration
                    num = den
                    den = b
                end
                return cf
            ```
    =#
    h = Vector{Int}()
    a, b = numerator(q), denominator(q)
    while b != 0
        append!(h, a ÷ b)
        a, b = b, a % b
    end
    return ContinuedFraction(h)
end

# uh, cuz why not. Of course we might want to write these values to disk.
function read(s::IO)
    head = read(s)
    orbit = read(s)
    ContinuedFraction(head, orbit)
end

function write(s::IO, cf::ContinuedFraction)
    write(s, head(cf), orbit(cf))
end

function visualize(cf::ContinuedFraction)::String
    # This is one of the coolest things I have ever discovered.
    if terminates(cf)
        return join(cf.head, " + 1/(") *
            ")" ^ (length(cf.head) - 1)
    else
        return join(cf.head, " + 1/(") *
            " + 1/(" *
            join(cf.orbit, " + 1/(") *
            " + ... " *
            ")" ^ (length(cf.head)+length(cf.orbit)-1)
    end
end

period(cf::ContinuedFraction)::Int = length(cf.orbit)
terminates(cf::ContinuedFraction)::Bool = cf.orbit == Vector{Int}()
Base.length(cf::ContinuedFraction)::Int = Inf ? length(cf.orbit) > 0 : length(cf.head)
