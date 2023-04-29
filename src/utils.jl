"""
    uniform([rng=GLOBAL_RNG], a::T, b::T) where {T<:AbstractFloat}
    uniform([rng=GLOBAL_RNG], a::Real, b::Real)
Generate a random number in the interval [a, b), uniformly distributed,
using the provided random number generator `rng`.
The arguments `a` and `b` must be of the same subtype of AbstractFloat.

# Arguments
- `rng::AbstractRNG`: The random number generator to be used.
- `a::T`: The lower bound of the interval (inclusive).
- `b::T`: The upper bound of the interval (exclusive).

# Returns
- `T`: A random number in the interval [a, b).
"""
function uniform(rng::AbstractRNG, a::T, b::T) where {T<:AbstractFloat}
    return (b - a) * rand(rng, T) + a
end

function uniform(rng::AbstractRNG, a::Real, b::Real)
    uniform(rng, float.(promote(a, b))...)
end

uniform(a::Real, b::Real) = uniform(Random.default_rng(), a, b)

noiseε(rng::AbstractRNG) = pnoise1(uniform(rng, 0, 10000)) - 1
