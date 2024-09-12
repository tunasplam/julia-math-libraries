#=
    Basic statistics go here
=#

function variance(l)
    # NOTE this is thousands of times faster than traditional approach
    return mean(map((x) -> x^2, l)) - mean(l)^2
end

function mean(l)
    return sum(l) / length(l)
end
