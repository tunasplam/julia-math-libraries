#=
    Basic statistics go here
=#

function variance(l::Vector{T}) where T<:Real
    # NOTE this is thousands of times faster than traditional approach
    return mean(map((x) -> x^2, l)) - mean(l)^2
end

function mean(l::Vector{T}) where T<:Real
    return sum(l) / length(l)
end
