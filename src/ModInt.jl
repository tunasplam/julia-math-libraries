#=
For integer rings. This might make PE problems easier.
Should work for BigInteger as well. Just the basics for now.
=#

struct ModInt
    x::Integer
    m::Integer

    function ModInt(x::Integer, m::Integer)
        new(x, m)
    end
end

function Base.:+(a::ModInt, b::ModInt)::ModInt
    @assert a.m = b.m
    return ModInt((a + b) % m, m)
end

function Base.:-(a::ModInt, b::ModInt)::ModInt
    @assert a.m = b.m
    return ModInt((a - b) % m, m)
end

function Base.:*(a::ModInt, b::ModInt)::ModInt
    @assert a.m = b.m
    return ModInt((a * b) % m, m)
end

function Base.:÷(a::ModInt, b::ModInt)::ModInt
    @assert a.m = b.m
    return ModInt((a ÷ b) % m, m)
end

function Base.:/(a::ModInt, b::ModInt)::ModInt
    @assert a.m = b.m
    return ModInt((a / b) % m, m)
end
