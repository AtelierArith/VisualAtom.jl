module VisualAtom

using Random
using TOML
using Printf: @sprintf

using ProgressMeter: @showprogress
using ToStruct: tostruct
using StaticArrays: @SVector
using StatsBase: sample
using Images: N0f8, RGB, save
using ImageDraw: draw!, Point, LineSegment

include("types.jl")
include("perlin_noise.jl")
include("renderer.jl")
include("utils.jl")

end
