
#=
	Also listed here: Some interesting properties of Fibonnaci numbers
	that I have found through playing around.

	- A001175 residues of Fib sequence mod k
=#

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
function fibonnaci(n::Integer) 
	return Fibonnaci((0,1), n)
end

# T allows us to use BigInts instead of Ints.
# Called like fibonnaci(10^14, BigInt)
function fibonnaci(n::Integer, T::Type)
	return Fibonnaci{T}((0,1), n)
end

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

#=
	mutable - can change the fields
	struct - its a class
	T <: Integer - takes any type T that is a subtype of Integer
=#
mutable struct Tribonnaci{T<:Integer}
	# The last three values stored as a tuple of type T
	last3::Tuple{T, T, T}
	# nth term in sequence
	n::Int
end
# explicitly listing out the different ways that the constructor
# handles different types of args.
tribonnaci(n::Integer) = Tribonnaci((1,1,1), n)
# This allows us to use BigInts instead of Ints.
# Called like fibonnaci(10^14, BigInt)
tribonnaci(n::Integer, T::Type) = Tribonnaci{T}((1,1,1), n)

# State default set to 1. Theres a reason why i just dunno how to explain.
function Base.iterate(T::Tribonnaci, state=1)
	if state == 1 || state == 2 || state == 3
		# If at the initial condition, return 1 (the first)
		# Fibonnaci value as well as 2 for state
		(1, state + 1)
	# check end condition, if there will be one.
	elseif state > T.n
		nothing
	else
		# Set the last2 values to be the new last two values
		T.last3 = T.last3[2], T.last3[3], sum(T.last3)
		# "yield" the new value and the new state
		(T.last3[3], state + 1)
	end
end

#=
	mutable - can change the fields
	struct - its a class
	T <: Integer - takes any type T that is a subtype of Integer
=#
mutable struct Tribonnaci_mod_k{T<:Integer}
	# The last three values stored as a tuple of type T
	last3::Tuple{T, T, T}
	# nth term in sequence
	n::Int
	k::Int
end
# explicitly listing out the different ways that the constructor
# handles different types of args.
tribonnaci_mod_k(n::Integer, k::Integer) = Tribonnaci_mod_k((1,1,1), n, k)
# This allows us to use BigInts instead of Ints.
# Called like fibonnaci(10^14, BigInt)
tribonnaci_mod_k(n::Integer, k::Integer, T::Type) = Tribonnaci_mod_k{T}((1,1,1), n, k)
Base.length(T::Tribonnaci_mod_k) = T.n

# State default set to 1. Theres a reason why i just dunno how to explain.
function Base.iterate(T::Tribonnaci_mod_k, state=1)
	if state == 1 || state == 2 || state == 3
		# If at the initial condition, return 1 (the first)
		# Fibonnaci value as well as 2 for state
		(1, state + 1)
	# check end condition, if there will be one.
	elseif state > T.n
		nothing
	else
		# Set the last2 values to be the new last two values
		T.last3 = T.last3[2], T.last3[3], sum(T.last3) % T.k
		# "yield" the new value and the new state
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
