#=
    Here we have a nice function that is suprisingly not in the base language
=#
function reciprocal(r::Rational)::Rational
    return denominator(r) // numerator(r)
end
