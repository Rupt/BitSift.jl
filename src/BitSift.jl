module BitSift

# Tools
export multiplicative_inverse
# Generator interface
export AbstractRNG
export query
export encode
# Generators
export Linear
export MultiplyWithCarry
export SplitMix64
export XorShift

abstract type AbstractRNG end

function query end
function encode end

include("tools.jl")
include("Linear.jl")
include("MultiplyWithCarry.jl")
include("SplitMix64.jl")
include("XorShift.jl")

end  # module BitSift
