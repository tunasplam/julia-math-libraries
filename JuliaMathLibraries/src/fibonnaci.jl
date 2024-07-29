
#=
	Also listed here: Some interesting properties of Fibonnaci numbers
	that I have found through playing around.

	- A001175 residues of Fib sequence mod k
=#

include("./sequence.jl")
using Printf
using Base.MathConstants

#=
	mutable - can change the fields
	struct - its a class
	T <: Integer - takes any type T that is a subtype of Integer
=#
mutable struct Fibonnaci{T<:Integer}
	# The last two values stored as a tuple of type T
	last2::Tuple{T, T}
	# nth term in sequence
	n::Int
end
# explicitly listing out the different ways that the constructor
# handles different types of args.
# NOTE THAT WE SEED THE LAST TWO VALUES HERE!
fibonnaci(n::Integer) = Fibonnaci((0,1), n)
# This allows us to use BigInts instead of Ints.
# Called like fibonnaci(10^14, BigInt)
fibonnaci(n::Integer, T::Type) = Fibonnaci{T}((0,1), n)

# State default set to 1. Theres a reason why i just dunno how to explain.
function Base.iterate(F::Fibonnaci, state=1)
	if state == 1
		# If at the initial condition, return 1 (the first)
		# Fibonnaci value as well as 2 for state
		(1, 2)
	# check end condition, if there will be one.
	elseif state > F.n
		nothing
	else
		# Set the last2 values to be the new last two values
		F.last2 = F.last2[2], sum(F.last2)
		# "yield" the new value and the new state
		(F.last2[2], state + 1)
	end
end

# Lets us use formula to grab nth term using indexing.
function Base.getindex(F::Fibonnaci, n::Int)
	0 <= n || throw(BoundsError(F, n))
	# uses binet's formula
	# TODO speed up i believe since one of these terms is vanishingly small
	# at sufficiently large n
	return (φ^n - (-φ)^(-n))/sqrt(5)
end

Base.length(F::Fibonnaci) = F.n
Base.firstindex(F::Fibonnaci) = 1
Base.lastindex(F::Fibonnaci) = length(F)
Base.getindex(F::Fibonnaci, i::Number) = F[convert(Int, i)]
Base.getindex(F::Fibonnaci, I) = [F[i] for i in I]

#=
	Generates the fibonnaci sequence mod some integer k. Values never rise
	above k :) Will be very very fast for us.
=#
mutable struct Fibonnanci_mod_k{T<:Integer}
	last2::Tuple{T, T}
	# nth term
	n::Int
	# modulo
	k::Int
end
fibonnaci_mod_k(n::Integer, k::Integer) = Fibonnanci_mod_k((0,1), n, k)
fibonnaci_mod_k(n::Integer, k::Integer, T::Type) = Fibonnanci_mod_k{T}((0,1), n, k)

function Base.iterate(F::Fibonnanci_mod_k, state=1)
	if state == 1
		(1, 2)
	elseif state > F.n
		nothing
	else
		F.last2 = F.last2[2] % F.k, sum(F.last2) % F.k
		(F.last2[2], state + 1)
	end
end

function Base.getindex(F::Fibonnanci_mod_k, n::Int)
	0 <= n || throw(BoundsError(F, n))
	# uses binet's formula
	# TODO speed up i believe since one of these terms is vanishingly small
	# at sufficiently large n
	return round((φ^n - (-φ)^(-n))/sqrt(5)) % F.k
end

Base.length(F::Fibonnanci_mod_k) = F.n
Base.firstindex(F::Fibonnanci_mod_k) = 1
Base.lastindex(F::Fibonnanci_mod_k) = length(F)
Base.getindex(F::Fibonnanci_mod_k, i::Number) = F[convert(Int, i)]
Base.getindex(F::Fibonnanci_mod_k, I) = [F[i] for i in I]


mutable struct Tribonnaci{T<:Integer}
	# The last three values stored as a tuple of type T
	last3::Tuple{T, T, T}
	# nth term in sequence
	n::Int
end

tribonnaci(n::Integer) = Tribonnaci((1,1,1), n)
tribonnaci(n::Integer, T::Type) = Tribonnaci{T}((1,1,1), n)

function Base.iterate(T::Tribonnaci, state=1)
	if state == 1 || state == 2 || state == 3
		(1, state + 1)
	elseif state > T.n
		nothing
	else
		T.last3 = T.last3[2], T.last3[3], sum(T.last3)
		(T.last3[3], state + 1)
	end
end

mutable struct Tribonnaci_mod_k{T<:Integer}
	last3::Tuple{T, T, T}
	n::Int
	k::Int
end

tribonnaci_mod_k(n::Integer, k::Integer) = Tribonnaci_mod_k((1,1,1), n, k)
tribonnaci_mod_k(n::Integer, k::Integer, T::Type) = Tribonnaci_mod_k{T}((1,1,1), n, k)
Base.length(T::Tribonnaci_mod_k) = T.n

function Base.iterate(T::Tribonnaci_mod_k, state=1)
	if state == 1 || state == 2 || state == 3
		(1, state + 1)
	elseif state > T.n
		nothing
	else
		T.last3 = T.last3[2], T.last3[3], sum(T.last3) % T.k
		(T.last3[3], state + 1)
	end
end

function fibonnaci_sequence(n::Integer, T::Type=Int)
	#=
	Returns first n terms of the fibonnaci sequence
	I am sure this can be done better BTW.
	=#
	fibs = zeros(n)
	j = 1
	for i in fibonnaci(n, T)
		fibs[j] = i
		j += 1
	end
	return fibs
end

function A001175(n)
	#=
	https://oeis.org/search?q=20%2C24%2C16%2C12%2C24%2C60%2C10%2C24%2C28%2C48&language=english&go=Search
	Generates the first n entries of A001175
	Pisano periods (or numbers) which are the periods of the Fibonnaci
	numbers mod n.

	NOTE that there IS a formula for the nth term using the primefactorization
	of n!

	TODO
	How to make this better? Notice the hardcoded length of fibonnaci
	sequence to generate. Can we get a good estimate of that value?
	=#
	hehe = ones(Int, n)
	for k in 2:n
		test = []
		for i in fibonnaci_mod_k(150, k)
			append!(test, i % 10)
		end
		hehe[k] = length(check_sequence_for_cycle(test))
	end
	return hehe
end
