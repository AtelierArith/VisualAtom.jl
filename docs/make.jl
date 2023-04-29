using VisualAtom
using Documenter

DocMeta.setdocmeta!(VisualAtom, :DocTestSetup, :(using VisualAtom); recursive=true)

makedocs(;
    modules=[VisualAtom],
    authors="Satoshi Terasaki <AtelierArith.math@gmail.com> and contributors",
    repo="https://github.com/AtelierArith/VisualAtom.jl/blob/{commit}{path}#{line}",
    sitename="VisualAtom.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://AtelierArith.github.io/VisualAtom.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
        "API" => "api.md",
    ],
)

deploydocs(;
    repo="github.com/AtelierArith/VisualAtom.jl",
    devbranch="main",
)
