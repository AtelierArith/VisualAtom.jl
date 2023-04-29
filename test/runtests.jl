using TOML
using Test
using StableRNGs
using PyCall
using VisualAtom

# \lesssim<tab>
≲(x,y) = (x < y) | (x ≈ y)

@testset "pnoise1" begin
    pynoise = pyimport("noise")
    rng = StableRNG(123)
    xs = [VisualAtom.uniform(rng, 0, 10000) for _ in 1:100]
    @test VisualAtom.pnoise1.(xs) == pynoise.pnoise1.(xs)
end

@testset "types.jl/Config" begin
    config = VisualAtom.Config(joinpath(@__DIR__, "ref_files", "config.toml"))
    @test config.num_categories == 1000
    @test config.num_instances == 1000
    @test config.image_size == 512
    @test config.vertex_num_min == 200
    @test config.vertex_num_max == 1000
    @test config.line_num_min == 1
    @test config.line_num_max == 200
    @test config.perlin_min == 0
    @test config.freq_min == 0   
    @test config.freq_max == 20
    @test config.oval_rate == 2
    @test config.radius_min == 10
    @test config.max_line_width == 0.1
end

@testset "types.jl/Atom" begin
    rng = StableRNG(123)
    config = VisualAtom.Config(joinpath(@__DIR__, "ref_files", "config.toml"))
    # VisualAtom.Config(1000, 1000, 512, 200, 1000, 1, 200, 0.0, 0, 20, 2.0, 10, 0.1)
    atom = VisualAtom.Atom(rng, config)
    @test atom.q == 243
    @test atom.K == 79
    @test atom.η == 2.676233724564411
    @test atom.line_width == 0.004273056581197765
    @test atom.radius == 13
    @test atom.n₁ == 17
    @test atom.n₂ == 15
    @test atom.λ₁ == 0.5
    @test atom.λ₂ == 0.5
    @test atom.oval_rate_x == 1.5150451217580685
    @test atom.oval_rate_y == 1.4950417174686346
end

@testset "utils.jl/uniform with rng" begin
    rng = StableRNG(123)
    data = [VisualAtom.uniform(rng, -1, 2) for _ in 1:100]
    @test all(-1 .≲ data)
    @test all(data .≲ 2)

    @test typeof(VisualAtom.uniform(rng, -1f0, 1f0)) == Float32
    @test typeof(VisualAtom.uniform(rng, -1f0, 1)) == Float32
    @test typeof(VisualAtom.uniform(rng, -1, 1f0)) == Float32
    @test typeof(VisualAtom.uniform(rng, -1., 1.)) == Float64
    @test typeof(VisualAtom.uniform(rng, -1f0, 1.)) == Float64
    @test typeof(VisualAtom.uniform(rng, -1, 1)) == Float64
end

@testset "utils.jl/uniform without rng" begin
    data = [VisualAtom.uniform(-1, 2) for _ in 1:100]
    @test all(-1 .≲ data)
    @test all(data .≲ 2)

    @test typeof(VisualAtom.uniform(-1f0, 1f0)) == Float32
    @test typeof(VisualAtom.uniform(-1f0, 1)) == Float32
    @test typeof(VisualAtom.uniform(-1, 1f0)) == Float32
    @test typeof(VisualAtom.uniform(-1., 1.)) == Float64
    @test typeof(VisualAtom.uniform(-1f0, 1.)) == Float64
    @test typeof(VisualAtom.uniform(-1, 1)) == Float64
end
