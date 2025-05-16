#=
For problems where we have values in different bases.

# TODO make sure we cannot have negative 0
# TODO what about adding values with different bases? only do that if we need to.
=#

mutable struct IntBaseK
    digits::Vector{<:Integer}
    base::Integer
    negative::Bool

    function IntBaseK(s::String, base::Integer)
        #=Instantiate a value in base k directly by passing string representation
        =#
        for c in s
            if c == '-'
                continue
            end
            if parse(Int, c) ≥ base
                throw("Attempted to create invalid IntBaseK, digits:$s, base:$base")
            end
        end
        new(reverse(digits(parse(Int, s))), base, '-' in s ? true : false)
    end

    function IntBaseK(x::Integer, base::Integer)
        #=For converting base 10 integer to a different base
        =#
        negative = false
        if x < 0
            negative = true
            x *= -1
        end

        if x == 0
            return new(Vector{Integer}([0]), base, false)
        end

        digits = Vector{Integer}()
        for k in floor(Int,log(base,x)):-1:1
            d = base^k
            push!(digits, x ÷ d)
            x -= (x ÷ d) * d
        end
        # at final bit. either 0 or 1.
        push!(digits, x)
        new(digits, base, negative)
    end

    function IntBaseK(x::IntBaseK, base::Integer)
        #=For converting an integer from one base to another
        =#
        if x.base == base
            return x
        end
        # TODO convert to a different base.
    end

    function IntBaseK(digits::Vector{<:Integer}, base::Integer, negative::Bool=false)
        new(digits, base, negative)
    end
end

function Base.:(==)(x::IntBaseK, y::IntBaseK)::Bool
    return x.base == y.base && x.digits == y.digits && x.negative == y.negative
end

function Base.:>(x::IntBaseK, y::IntBaseK)::Bool
    if x.negative && ! y.negative
        return false
    elseif ! x.negative && y.negative
        return true
    end

    if x.negative && y.negative
        t = x
        x = y
        y = t
    end

    if length(x.digits) > length(y.digits)
        return true
    elseif length(x.digits) < length(y.digits)
        return false
    end
    for d in eachindex(x.digits)
        if x.digits[d] > y.digits[d]
            return true
        elseif x.digits[d] < y.digits[d]
            return false
        end
    end
end

function Base.:<(x::IntBaseK, y::IntBaseK)::Bool
    return ! (x == y) && ! ( x > y)
end

function Base.:≥(x::IntBaseK, y::IntBaseK)::Bool
    return (x > y) || (x == y)
end

function Base.:≤(x::IntBaseK, y::IntBaseK)::Bool
    return (x < y) || (x == y)
end

function Base.:+(x::IntBaseK, y::IntBaseK)::IntBaseK
    # uses simple add-and-carry.
    @assert x.base == y.base

    # TODO negatives. implement when we need to
    if x.negative || y.negative
        throw("Not Implemented")
    end

    # make longest value be first
    if length(y.digits) > length(x.digits)
        t = x
        x = y
        y = t
    end

    digits = zeros(Integer, length(x.digits))
    x_digits, y_digits = reverse(x.digits), reverse(y.digits)
    carry = 0
    m = length(y.digits)
    for k in 1:m
        s = (x_digits[k] + y_digits[k]) % x.base
        digits[k] = (s + carry) % x.base
        carry = (x_digits[k] + y_digits[k] + carry) ÷ x.base
    end

    # now the remaining digits of x
    for k in m+1:length(x.digits)
        digits[k] = (x_digits[k] + carry) % x.base
        carry = (x_digits[k] + carry) ÷ x.base
    end
    if carry > 0
        push!(digits, carry)
    end
    return IntBaseK(reverse(digits), x.base)
end

function Base.:-(x::IntBaseK, y::IntBaseK)::IntBaseK
    throw("Not Implemented")
end

function Base.:*(x::IntBaseK, y::IntBaseK)::IntBaseK
    throw("Not Implemented")
end

function Base.:÷(x::IntBaseK, y::IntBaseK)::IntBaseK
    throw("Not Implemented")
end

function count_sum_carries(x::IntBaseK, y::IntBaseK)::Integer
    #=This is used in Kummer's Theorem. Basically adding but we count
    the carries and return that.
    =#

    # make longest value be first
    if length(y.digits) > length(x.digits)
        t = x
        x = y
        y = t
    end

    digits = zeros(Integer, length(x.digits))
    x_digits, y_digits = reverse(x.digits), reverse(y.digits)
    carry = 0
    ret = 0
    m = length(y.digits)
    for k in 1:m
        s = (x_digits[k] + y_digits[k]) % x.base
        digits[k] = (s + carry) % x.base
        carry = (x_digits[k] + y_digits[k] + carry) ÷ x.base
        if carry > 0
            ret += 1
        end
    end

    # now the remaining digits of x
    for k in m+1:length(x.digits)
        digits[k] = (x_digits[k] + carry) % x.base
        carry = (x_digits[k] + carry) ÷ x.base
        if carry > 0
            ret += 1
        end
    end
    if carry > 0
        push!(digits, carry)
    end
    return ret
end
