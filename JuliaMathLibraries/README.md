# How to use

### Activating Package Env

in Command line

```
julia
]
activate .
```

### Adding Dependencies
`add [Package]`

### Running Tests

`test JuliaMathLibraries`

### setting up separate test files

Create new file in `test`.

In `runtests.jl`:
`include("new_test_file.jl")`

Now `test JuliaMathLibraries` will run all tests