function uniform(rng::AbstractRNG, a::T, b::T) where {T<:AbstractFloat}
    return (b - a) * rand(rng, T) + a
end

function uniform(rng::AbstractRNG, a::Real, b::Real)
    uniform(rng, float.(promote(a, b))...)
end

uniform(a::Real, b::Real) = uniform(Random.default_rng(), a, b)

noiseε(rng::AbstractRNG) = pnoise1(uniform(rng, 0, 10000)) - 1
