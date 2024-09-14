
#=
	Also listed here: Some interesting properties of Fibonnaci numbers
	that I have found through playing around.

	- A001175 residues of Fib sequence mod k
=#

#=
	mutable structs -> structs which you can change the fields of
	this struct represents a term of the Fibonnaci sequence
	and is iterable.
	
	Parameters:
	T <: Integer - values of the sequence are type T that is a
		subtype of Integer. This lets this work on BigInts

	Properties:
	last2::Tuple{T,T} - the previous two terms in the fibonnaci seq
	n::Int - the number of terms we wish to generate (stop condition)

	It may be helpful to think of these like Recurisve CTEs in postgres
	and the process of proof by induction. We have an initial case, an
	inductive step, and a stop condition.

	example:
		for i in fibonnaci(10)
	loops over the first 10 terms of the sequence

	for big ints:
		for i in fibonnaci(10^14, BigInt)

=#

mutable struct Fibonnaci{T<:Integer}
	last2::Tuple{T, T}
	n::Int
end

#=
	this is the 'initial' state of the iterator
	Kicks off the 'induction steps' by providing the initial
	two terms of the sequence as well as the stop condition

	Notice that it returns the struct that represents the 1st
	term in the fibonnaci seq
=#
function fibonnaci(n::Integer)
	return Fibonnaci((0,1), n)
end

# T allows us to use BigInts instead of Ints.
function fibonnaci(n::Integer, T::Type)
	return Fibonnaci{T}((0,1), n)
end

# i is which index in the sequence the iterator is at
# this returns a tuple where the first value is the ith fib term
# and i is the next index.
function Base.iterate(F::Fibonnaci, i=1)
	if i == 1
		# If at the initial condition, return 1 (the first)
		# Fibonnaci value as well as 2 for index
		return 1, 2
	# check stop condition
	elseif i > F.n
		return nothing
	else
		# Set the last2 values to be the new last two values
		F.last2 = F.last2[2], sum(F.last2)
		# "yield" the new value and the next index
		return F.last2[2], i + 1
	end
end
Base.length(F::Fibonnaci) = F.n

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
Base.length(F::Fibonnanci_mod_k) = F.n

#=
	See documentation for Fibonnaci
=#
mutable struct Tribonnaci{T<:Integer}
	last3::Tuple{T, T, T}
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
		return T.last3[3], state + 1
	end
end
Base.length(T::Tribonnaci) = T.n

mutable struct Tribonnaci_mod_k{T<:Integer}
	last3::Tuple{T, T, T}
	n::Int
	k::Int
end

tribonnaci_mod_k(n::Integer, k::Integer) = Tribonnaci_mod_k((1,1,1), n, k)
tribonnaci_mod_k(n::Integer, k::Integer, T::Type) = Tribonnaci_mod_k{T}((1,1,1), n, k)

# State default set to 1. Theres a reason why i just dunno how to explain.
function Base.iterate(T::Tribonnaci_mod_k, state=1)
	if state == 1 || state == 2 || state == 3
		# If at the initial condition, return 1 (the first)
		# Fibonnaci value as well as 2 for state
		return 1, state + 1

	elseif state > T.n
		return nothing

	else
		T.last3 = T.last3[2], T.last3[3], sum(T.last3) % T.k
		return T.last3[3], state + 1
	end
end
Base.length(T::Tribonnaci_mod_k) = T.n

# TODO this could probably just be replaced by collect lol
# TODO 90% sure theres a better way to generate fib seq somewhere
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
