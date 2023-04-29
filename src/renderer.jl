"""
    render!(rng::AbstractRNG, atom::Atom, canvas::AbstractMatrix)

Render an atom onto a canvas, modifying the canvas in-place. The atom's properties and a random number generator are used to generate the image.

# Arguments
- `rng::AbstractRNG`: The random number generator to be used.
- `atom::Atom`: The atom instance with properties defining its appearance.
- `canvas::AbstractMatrix`: The canvas (matrix of color values) onto which the atom will be rendered.

# Returns
- `canvas::AbstractMatrix`: The modified canvas with the rendered atom.
"""
function render!(
    rng::AbstractRNG,
    atom::Atom,
    canvas::AbstractMatrix,
)
    q = atom.q
    K = atom.K
    η = atom.η

    line_width = atom.line_width
    radius = atom.radius
    n₁ = atom.n₁
    n₂ = atom.n₂
    λ₁ = atom.λ₁
    λ₂ = atom.λ₂
    oval_rate_x = atom.oval_rate_x
    oval_rate_y = atom.oval_rate_y

    θ = 2π / q

    H, W = size(canvas)
    start_pos_h = (H + H * uniform(rng, -1, 1)) / 2
    start_pos_w = (W + W * uniform(rng, -1, 1)) / 2

    vertex_x = map(0:q) do i
        θᵢ = i * θ
        cos(i * θ) * radius * oval_rate_x + start_pos_w
    end

    vertex_y = map(0:q) do i
        θᵢ = i * θ
        sin(i * θ) * radius * oval_rate_y + start_pos_h
    end

    for _ in 1:K
        grayscale = rand(rng)
        linecolor = RGB{N0f8}(grayscale, grayscale, grayscale)
        noise_x = map(0:q) do i
            θᵢ = i * θ
            η * noiseε(rng) - λ₁ * sin(n₁ * θᵢ) - λ₂ * sin(n₂ * θᵢ)
        end
        noise_y = map(0:q) do i
            θᵢ = i * θ
            η * noiseε(rng) - λ₁ * sin(n₁ * θᵢ) - λ₂ * sin(n₂ * θᵢ)
        end
        # consider boundary condition
        noise_x[end] = noise_x[begin]
        noise_y[end] = noise_y[begin]

        for i in 0:q
            θᵢ = i * θ
            vertex_x[begin+i] -= cos(θᵢ) * (noise_x[begin+i] - line_width)
            vertex_y[begin+i] -= sin(θᵢ) * (noise_y[begin+i] - line_width)
        end

        for i in 1:q
            p1 = Point(floor(Int, vertex_x[i]), floor(Int, vertex_y[i]))
            p2 = Point(floor(Int, vertex_x[i+1]), floor(Int, vertex_y[i+1]))
            draw!(canvas, LineSegment(p1, p2), linecolor)
        end
    end
    canvas
end

"""
    save_images(rng::AbstractRNG, atom::Atom; save_dir::AbstractString, num_instances::Int, H::Int, W::Int)

Render and save images of the Atom instance `atom` onto a canvas with specified dimensions. The images will be saved in the specified directory.

# Arguments
- `rng::AbstractRNG`: The random number generator to be used.
- `atom::Atom`: The atom instance with properties defining its appearance.
- `save_dir::AbstractString`: The directory where the images will be saved.
- `num_instances::Int`: The number of instances (images) to generate and save.
- `H::Int`: The height of the canvas.
- `W::Int`: The width of the canvas.

# Returns
- This function does not return a value; it saves generated images to the specified directory.
"""
function save_images(
    rng::AbstractRNG, atom::Atom;
    save_dir::AbstractString,
    num_instances::Int,
    H::Int,
    W::Int,
)
    canvas = zeros(RGB{N0f8}, H, W)
    for instance_id in 0:(num_instances-1)
        render!(rng, atom, canvas)
        name = @sprintf "vertex_%04d_instance_%04d.png" atom.q instance_id
        save(joinpath(save_dir, name), canvas)
        fill!(canvas, 0)
    end
end

"""
    generate_instances(config::Config; save_root::AbstractString, category_id::Int, num_instances::Int)

Generate instances of Atom images based on the configuration object and save them to the specified directory. The images will be saved in a subdirectory named after the category ID.

# Arguments
- `config::Config`: The configuration object containing parameter ranges for the Atom generation.
- `save_root::AbstractString`: The root directory where the images will be saved.
- `category_id::Int`: The category ID, used for generating the seed and naming the output subdirectory.
- `num_instances::Int`: The number of instances (images) to generate and save.

# Returns
- This function does not return a value; it saves generated images to the specified directory.
"""
function generate_instances(config::Config;
    save_root::AbstractString,
    category_id::Int,
    num_instances::Int,
)
    H = W = config.image_size
    seed = category_id
    atom_rng = Xoshiro(seed)
    atom = Atom(atom_rng, config)
    save_dir = joinpath(
        save_root,
        @sprintf "%05d" category_id
    )
    rng = Xoshiro(seed)
    save_images(rng, atom; save_dir, num_instances, H, W)
end
