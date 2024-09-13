#=
Speed comparisons for mobius function
=#

using BenchmarkTools
using JuliaMathLibraries: μ, mobius_old

# Round 1: Winner: mobius_old
@benchmark μ setup=(x=rand(Int, 10^5))
#=
BenchmarkTools.Trial: 10000 samples with 1000 evaluations.
 Range (min … max):  1.290 ns … 19.280 ns  ┊ GC (min … max): 0.00% … 0.00%
 Time  (median):     1.450 ns              ┊ GC (median):    0.00%
 Time  (mean ± σ):   1.440 ns ±  0.313 ns  ┊ GC (mean ± σ):  0.00% ± 0.00%

   ▇▆▂▂           ▂█▆ ▃▂              ▂▅ ▂                   ▂
  ▄████▆▃▃▁▁▁▁▃▁▁▁███▄███▇▇▆▆▆▅▁▅▆▆▅▆▁██▃███▆▆▅▆▆▆▁▅▆██▇█▇▇▅ █
  1.29 ns      Histogram: log(frequency) by time     1.81 ns <

 Memory estimate: 0 bytes, allocs estimate: 0.

=#

@benchmark mobius_old setup=(x=rand(Int, 10^5))
#=
BenchmarkTools.Trial: 10000 samples with 1000 evaluations.
 Range (min … max):  1.290 ns … 28.119 ns  ┊ GC (min … max): 0.00% … 0.00%
 Time  (median):     1.310 ns              ┊ GC (median):    0.00%
 Time  (mean ± σ):   1.343 ns ±  0.409 ns  ┊ GC (mean ± σ):  0.00% ± 0.00%

   █ ▂                                                        
  ▂█▁█▂▃▃▁▂▁▂▂▁▂▁▁▁▂▂▁▂▁▁▂▁▂▁▄▃▁▂▁▂▁▂▁▁▂▁▂▂▁▂▁▁▁▁▂▁▁▁▂▁▁▁▁▂▃ ▂
  1.29 ns        Histogram: frequency by time        1.63 ns <

 Memory estimate: 0 bytes, allocs estimate: 0.
=#

# Round 2: Winner: mobius_old
@benchmark μ setup=(x=rand(Int, 10^7))
#=
BenchmarkTools.Trial: 251 samples with 1000 evaluations.
 Range (min … max):  1.510 ns … 2.750 ns  ┊ GC (min … max): 0.00% … 0.00%
 Time  (median):     1.810 ns             ┊ GC (median):    0.00%
 Time  (mean ± σ):   1.824 ns ± 0.163 ns  ┊ GC (mean ± σ):  0.00% ± 0.00%

              ▆▄           █                                 
  ▃▁▁▁▁▄▆▃▁▂▁▂███▆▄▅█▆▄▄▄▃▄█▆▄█▄▄▇▃▁▄▄▂▅▂▄▄▂▂▃▄▄▃▂▁▁▂▂▂▁▁▂▃ ▃
  1.51 ns        Histogram: frequency by time       2.26 ns <

 Memory estimate: 0 bytes, allocs estimate: 0.
=#

@benchmark mobius_old setup=(x=rand(Int, 10^7))
#=
BenchmarkTools.Trial: 262 samples with 1000 evaluations.
 Range (min … max):  1.490 ns … 2.330 ns  ┊ GC (min … max): 0.00% … 0.00%
 Time  (median):     1.790 ns             ┊ GC (median):    0.00%
 Time  (mean ± σ):   1.814 ns ± 0.159 ns  ┊ GC (mean ± σ):  0.00% ± 0.00%

                █                                            
  ▃▂▃▁▃▂▂▃▃▁▂▃▂▃██▃▃▃▃▆▄▄▅▄▃▅▆▅▆▄▃▅▃▂▃▁▁▃▃▃▃▂▂▃▂▁▂▃▂▃▂▂▃▁▂▂ ▃
  1.49 ns        Histogram: frequency by time       2.25 ns <

 Memory estimate: 0 bytes, allocs estimate: 0.
=#
