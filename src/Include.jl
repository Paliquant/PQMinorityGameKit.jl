# setup project paths -
const _PATH_TO_SRC = dirname(pathof(@__MODULE__))
const _PATH_TO_BASE = joinpath(_PATH_TO_SRC, "base")

# load external packages that are required for the simulation
# ...

# load my codes -
include(joinpath(_PATH_TO_BASE, "Types.jl"))

