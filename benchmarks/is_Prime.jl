#=
    compare three scenarios:
    1. is J.is_prime
    2. generate list of first n primes and check if prime is within
    3. generate SortedSet of first n primes and check if prime is within

    VERDICT:
    use J.is_prime. it is massively faster.
=#

# You have to run these in the REPL in order for this to work.

using BenchmarkTools
using DataStructures
using JuliaMathLibraries

const J = JuliaMathLibraries

function scenario_1(max_n, trials)
    map(J.is_prime, map(abs, rand(1:max_n, trials)))
end

@benchmark scenario_1(10^5, 10^3)
#=
BenchmarkTools.Trial: 10000 samples with 1 evaluation.
 Range (min … max):  48.130 μs …  2.700 ms  ┊ GC (min … max): 0.00% … 95.99%
 Time  (median):     64.050 μs              ┊ GC (median):    0.00%
 Time  (mean ± σ):   64.952 μs ± 26.992 μs  ┊ GC (mean ± σ):  0.40% ±  0.96%

                  ▂▃▅▄▅▇▆█▇▇▇▆▇▆▅▆▄▄▄▃▃▁▁▁                     
  ▂▂▁▂▂▂▂▃▃▃▃▄▅▆▇█████████████████████████▇▇▆▅▅▄▄▄▄▄▃▃▃▃▃▃▃▂▂ ▅
  48.1 μs         Histogram: frequency by time          82 μs <

 Memory estimate: 16.94 KiB, allocs estimate: 3.

=#

function scenario_2(n, max_n, trials)
    f = x -> x in n
    map(f, map(abs, rand(1:max_n, trials)))
end

# generate n outside since it should only be generated once
@benchmark scenario_2(J.primes_leq(10^5), 10^5, 10^3)
#=
BenchmarkTools.Trial: 852 samples with 1 evaluation.
 Range (min … max):  5.280 ms …  10.593 ms  ┊ GC (min … max): 0.00% … 0.00%
 Time  (median):     5.598 ms               ┊ GC (median):    0.00%
 Time  (mean ± σ):   5.868 ms ± 716.254 μs  ┊ GC (mean ± σ):  0.05% ± 0.46%

  ▅█▆▁▁▂▄▄▂▂▃▁▂▂▃▂▁            ▂▁                              
  ██████████████████▆█▅▆▇▆▆▆█▆▇██▇▇▇▇▆▄▆▆▇▇▆▇▆▆▄▅▇▆█▆▆▅▁▆▁▁▆▄ █
  5.28 ms      Histogram: log(frequency) by time      8.03 ms <

 Memory estimate: 441.22 KiB, allocs estimate: 14.
=#

@benchmark scenario_2(SortedSet(J.primes_leq(10^5)), 10^5, 10^3)
#=
BenchmarkTools.Trial: 2934 samples with 1 evaluation.
 Range (min … max):  1.561 ms … 83.207 ms  ┊ GC (min … max): 0.00% … 97.06%
 Time  (median):     1.600 ms              ┊ GC (median):    0.00%
 Time  (mean ± σ):   1.702 ms ±  1.540 ms  ┊ GC (mean ± σ):  3.36% ±  5.18%

   ██▆▅▃▂▁▁▁▁▂▁▁▁▂▂              ▁▃▂                         ▁
  ▇█████████████████▇▆▅▁▁▁▁▁▁▁▁▁▃████▅▆▄▅▃▃▄▄▅▃▃▅▄▃▄▃▄██▇▅▅▄ █
  1.56 ms      Histogram: log(frequency) by time     2.38 ms <

 Memory estimate: 2.98 MiB, allocs estimate: 43.
=#

function verify()
    # verify that all three methods yield the same results
    xs = rand(1:10^5, 10^3)
    s1 = map(J.is_prime, map(abs,xs))
    f = x -> x in J.primes_leq(10^5)
    s2 = map(f, map(abs, xs))
    f = x -> x in SortedSet(J.primes_leq(10^5))
    s3 = map(f, map(abs, xs))

    @assert s1 == s2
    @assert s2 == s3
    @assert s1 == s3
end

# all good.
verify()
