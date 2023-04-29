"""
    Config

A struct representing the configuration for generating atom instances and images.
"""
struct Config
    #=
    for category_id in 0:(num_categories-1)
    # setup Atom
    for instance_id in 0:(num_instances-1)
    # create canvas
    # draw waves on canvas and save as image
    end
    end
    =#
    num_categories::Int
    num_instances::Int
    #=
    H = W = image_size
    canvas = zeros(RGB{N08f}, H, W)
    =#
    image_size::Int

    # q ∼ rand(rng, vertex_num_min:vertex_num_max)
    vertex_num_min::Int
    vertex_num_max::Int

    # K ∼ rand(rng, line_num_min:line_num_max)
    line_num_min::Int
    line_num_max::Int

    # η ∼ uniform(rng, perlin_min, perlin_min + 4)
    perlin_min::Float64

    # n₁, n₂ = sample(rng, freq_min:freq_max, 2, replace=false)
    freq_min::Int
    freq_max::Int

    # oval_rate_x ∼ uniform(rng, 1, oval_rate)
    # oval_rate_y ∼ uniform(rng, 1, oval_rate)
    oval_rate::Float64

    # radius ∼ rand(rng, radius_min:(radius_min+50))
    radius_min::Int

    # line_width = uniform(rng, 0.0, max_line_width)
    max_line_width::Float64
end

Config(config_path::AbstractString)

"""
    Config(config_path::AbstractString)

Create a new `Config` instance by reading and parsing
the configuration file at the specified `config_path`.

# Arguments
- `config_path::AbstractString`: Path to the configuration file (TOML format).

# Returns
- `Config`: A new `Config` instance with properties read from the configuration file.
"""
function Config(config_path::AbstractString)
    tostruct(Config, TOML.parsefile(config_path))
end

"""
    Atom(config::Config)
    Atom([rng=GLOBAL_RNG], config::Config)

`Atom` struct representing the data structure proposed in [Visual Atoms: Pre-training Vision Transformers with Sinusoidal Waves](https://arxiv.org/abs/2303.01112).

# Arguments
- `config::Config`: A configuration object containing the parameter ranges.

# Returns
- `Atom`: A new `Atom` instance with randomly generated properties.
"""
Base.@kwdef struct Atom
    q::Int
    K::Int
    η::Float64
    line_width::Float64
    radius::Int
    n₁::Int
    n₂::Int
    λ₁::Float64
    λ₂::Float64
    oval_rate_x::Float64
    oval_rate_y::Float64
end

"""
    Atom(rng::AbstractRNG, config::Config)
# Arguments
- `rng::AbstractRNG`: The random number generator to be used.
- `config::Config`: A configuration object containing the parameter ranges.

# Returns
- `Atom`: A new `Atom` instance with randomly generated properties.
"""
function Atom(rng::AbstractRNG, config::Config)
    q = rand(rng, config.vertex_num_min:config.vertex_num_max) # vertex_number
    K = rand(rng, config.line_num_min:config.line_num_max) # line_draw_num
    perlin_max = config.perlin_min + 4
    η = uniform(rng, config.perlin_min, perlin_max)

    line_width = uniform(rng, 0.0, config.max_line_width)
    radius_max = config.radius_min + 50
    radius = rand(rng, config.radius_min:radius_max)
    n₁, n₂ = sample(rng, config.freq_min:config.freq_max, 2, replace=false)
    λ₁ = λ₂ = 0.5
    oval_rate_x = uniform(rng, 1, config.oval_rate)
    oval_rate_y = uniform(rng, 1, config.oval_rate)
    Atom(;
        q,
        K,
        η,
        line_width,
        radius,
        n₁,
        n₂,
        λ₁,
        λ₂,
        oval_rate_x,
        oval_rate_y,
    )
end

Atom(config::Config) = Atom(Random.default_rng(), config)
