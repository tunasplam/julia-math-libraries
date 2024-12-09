#=
    Continued fractions are cool. This was a lot of fun.
    We represent them with vectors as such:

    [1 2 3 4] = 1 + 1/(2+1/(3+(1/4)))

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

    TODO this needs to be its own package.
    TODO this needs to be prominently displayed.
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



# # this constructor below ensures that invalid orbits are not passed along
# @noinline __throw_continuedfraction_argerror(T) = throw(
#     ArgumentError(LazyString("invalid continued fraction: cannot have orbit of [0]"))
# )
# # Vector{Int}() is how to instantiate an empty vector [] of type Vector{Int}
# # and not Vector{Any}
# function ContinuedFraction{T}(head::T, orbit::T=Vector{Int}()) where T<:Vector{Int}
#     # trailing value of orbit cannot be 0
#     orbit[end] == 0 && 
# end

#ContinuedFraction(head::T) where T:Vector{Int} = ContinuedFraction{T}(head)

# uh, cuz why not. Of course we might want to write these values to disk.
function read(s::IO)
    head = read(s)
    orbit = read(s)
    ContinuedFraction(head, orbit)
end

function write(s::IO, cf::ContinuedFraction)
    write(s, head(cf), orbit(cf))
end

# these are what convert it between other Julia base types
function parse(q::Rational)::ContinuedFraction
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
    head = []
    a, b = numerator(q), denominator(q)
    while b != 0
        append!(head, a ÷ b)
        a, b = b, a % b
    end
    return ContinuedFraction(head)
end

function visualize(cf::Vector{Int})::String
    # TODO this needs to be adapted... badly
    # This is one of the coolest things I have ever discovered.
    return join(cf, " + 1/(") * ")" ^ (length(cf) - 1)
end

function cf_to_rational(cf::Vector{Int})::Rational
	#=
	Same as irrational but we don't have to worry about the formatting.
	This should always spit out a nice solution.
	Returns num // den AS A FRACTION (Rational)

	Note that the first value of cf is the whole part.
	=#

    @assert length(cf) > 0

    num = 1; den = cf[end]
	for i in length(cf)-1:-1:1
		# Keep adding and flipping. If you don't know whats going on
		# then work it out on paper.
		num += cf[i]*den

		temp = num
		num = den
		den = temp
	end

	# flipped one too many times so unflip here
	return den // num
end

function cf_to_float(cf::Vector; whole_part::Int=0)::Float
	#=
    Converts a cf to a float.

    Okay, this was something we apperenly only glanced the surface of
    all those years ago. This is actually something very cool.

    Consider a cf with orbit 2 [c1 c2 ;].

    Thus, x = 1/(c1 + 1/(c2 + x))
    Which equates to c1 x^2 + (c1c2 - 1)x + 1 - c2 = 0
    which is a quadratic equation.

    If fact, all of these setup quadratic equations to be solved.
    The problem is, the quadratic equations get nastier and nastier as the
    orbits increase.

    So that is not a feasible solution. (its a recurrence relation)
    So what we do instead is cheese it in a very unelegant manner

    []

    -----
    Here is the original documentation kept for nostalgiac purposes:

	Takes a continued fraction representing an irrational
	number and converts it to an irrational number.
	Remember, all irrational numbers have periodic continued fractions.

	There are two parts.. the first part is collapsing the cf.

	We have x = 1/(c[1] + 1/(cf[2] + 1/(cf[3] + x))
	for a cf with an orbit of 3.

	Once that is collapsed, it will give us
	x = (a1 + b1x)/(a2 + b2x)

	Which yields...
	b2x^2 + (a2 - b1)x - a1 = 0

	That can be solved using quadratic formula.
	We are only interested in the plus part of the answer.

	TODO
	HAS NOT BEEN TESTED THOROUGHLY.
    TODO i completely borked this
	=#

	# numerator constant and coefficient of x
	a1 = 1
    b1 = 0
	# denominator constant and coefficient of x
	a2 = cf[end]
    b2 = 1
	for i in length(cf)-1:-1:1
		a1 = cf[i]*a2 + a1
        b1 = cf[i]*b2 + b1
		
		# flip the fraction over by swapping
		temp = a1
		a1 = a2
		a2 = temp
		temp = b1
		b1 = b2
		b2 = temp
	end

	# set up and solve our quadratic equation.
    # TODO this algo seems to require the below function to have a specific
    # return style... but it does no longer. That is why i added testing :)
	result = solve_quadratic(b2, a2-b1, -a1, formatted=true, sol_type="plus")

	# Whole part, add it to the result. So result[1] will increase
	# by whole_part*result[2]
	if whole_part > 0
		result[1] = whole_part*result[2]
	end
	return result
end
