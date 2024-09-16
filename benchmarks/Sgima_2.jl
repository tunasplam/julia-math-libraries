using BenchmarkTools
using JuliaMathLibraries: divisors, prime_factorization

function s2_1(n::Integer)::Integer
    return reduce(+, map(x -> x^2, divisors(n)))
end

function s2_2(n::Integer)::Integer
	total = 1
	for (p, k) in prime_factorization(n)
		@inbounds @fastmath total *= (p^(2k + 2) - 1)÷(p^2 - 1)
	end
    return total
end

# s2_1 is incorrect. let's see if its even fast enough to be worth fixing.
for i in 1:100
    @show i
    @show s2_1(i), s2_2(i)
    @assert s2_1(i) == s2_2(i)
end

# for 10^5 it looks like the old way has a slight advantage
@benchmark s2_1 setup=(x=rand(Int, 10^5))
#=
BenchmarkTools.Trial: 10000 samples with 1000 evaluations.
 Range (min … max):  1.300 ns … 27.640 ns  ┊ GC (min … max): 0.00% … 0.00%
 Time  (median):     1.450 ns              ┊ GC (median):    0.00%
 Time  (mean ± σ):   1.504 ns ±  0.418 ns  ┊ GC (mean ± σ):  0.00% ± 0.00%

           ▂█▆▂▃                  ▁ ▁         ▁              ▁
  █▃▅▃▁▁▁▁▁██████▇▇▆▇▆▇▆▆█▆▇▇█▇▅▇███████▆▇▇█▇▇█▆▇▆▆▅▃▆▄▅▅▅▅▆ █
  1.3 ns       Histogram: log(frequency) by time     2.13 ns <

 Memory estimate: 0 bytes, allocs estimate: 0.
=#

@benchmark s2_2 setup=(x=rand(Int, 10^5))
#=
enchmarkTools.Trial: 10000 samples with 1000 evaluations.
 Range (min … max):  1.440 ns … 34.000 ns  ┊ GC (min … max): 0.00% … 0.00%
 Time  (median):     1.450 ns              ┊ GC (median):    0.00%
 Time  (mean ± σ):   1.559 ns ±  0.621 ns  ┊ GC (mean ± σ):  0.00% ± 0.00%

  █▇▂                           ▃▂               ▃▂          ▁
  ████▆▆▆▆▅▄▆▅▅▅▄▆▇▇▆▄▅▄▄▃▃▄▃▃▄▅██▅▄▂▄▃▃▂▃▅▄▃▂▄▄▃██▆▅▄▄▄▄▄▃▄ █
  1.44 ns      Histogram: log(frequency) by time     2.48 ns <

 Memory estimate: 0 bytes, allocs estimate: 0.
=#

# when allowing for bigger numbers, the pi series takes the prize.
# specifically, look at the max values of both. the tail on the first
# histogram is significantly worse than the second one.
@benchmark s2_1 setup=(x=rand(Int, 10^7))
#=
BenchmarkTools.Trial: 219 samples with 1000 evaluations.
 Range (min … max):  1.580 ns … 14.640 ns  ┊ GC (min … max): 0.00% … 0.00%
 Time  (median):     1.970 ns              ┊ GC (median):    0.00%
 Time  (mean ± σ):   2.086 ns ±  0.881 ns  ┊ GC (mean ± σ):  0.00% ± 0.00%

            ▂▂▄  ▂▄█ ▄  ▃                                     
  ▄▃▁▁▃▁▃▃▃▄███▇▇███▇█▇██▆▄█▆▄▄▅▇▅▃▆▃▄▄▅▄▁▃▃▄▃▁▃▄▁▃▁▁▁▄▁▄▃▁▃ ▄
  1.58 ns        Histogram: frequency by time        2.75 ns <

 Memory estimate: 0 bytes, allocs estimate: 0.
=#

@benchmark s2_2 setup=(x=rand(Int, 10^7))
#=
BenchmarkTools.Trial: 223 samples with 1000 evaluations.
 Range (min … max):  1.670 ns … 9.960 ns  ┊ GC (min … max): 0.00% … 0.00%
 Time  (median):     1.970 ns             ┊ GC (median):    0.00%
 Time  (mean ± σ):   2.057 ns ± 0.581 ns  ┊ GC (mean ± σ):  0.00% ± 0.00%

       ▄▄▁▃▃▃▂█ ▁▃ ▂       ▁                                 
  ▄▃▃▇▇███████████▇█▇▅▇▄▅▄▄█▄▄▄▄▄▁▁▃▅▁▃▁▁▁▁▁▁▁▁▄▁▁▁▃▁▁▃▁▃▁▃ ▄
  1.67 ns        Histogram: frequency by time       2.99 ns <

 Memory estimate: 0 bytes, allocs estimate: 0.

=#
