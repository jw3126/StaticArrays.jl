using Documenter, StaticArrays

makedocs(
         format = :html,
         modules = [StaticArrays, StaticArrays.FixedSizeArrays],
         sitename = "StaticArrays.jl",
         pages = [
            "Home" => "index.md",
            "API" => "pages/api.md",
            "Quick Start" => "pages/quickstart.md",
            ],
        )

deploydocs(
    repo = "github.com/JuliaArrays/StaticArrays.jl",
)
