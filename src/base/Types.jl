# Abstract types -
abstract type PQAbstractGameAgentStrategy end
abstract type PQAbstractGameAgent end
abstract type PQAbstractGameWorld end
abstract type PQAbstractGameSimulationContext end


# Basic game types below here -------------------------------------------------------------------------- #
mutable struct PQBasicMinorityGameKitStrategy <: PQAbstractGameAgentStrategy

    # data -
    strategy::Dict{String,Int}
    score::Int

    # default constructor -
    PQBasicMinorityGameKitStrategy() = new()
end

mutable struct PQBasicMinorityGameKitSimulationContext <: PQAbstractGameSimulationContext

    # data -
    numberOfSimulationSteps::Int64

    # default constructor -
    PQBasicMinorityGameKitSimulationContext() = new()
end

mutable struct PQBasicMinorityGameKitAgent <: PQAbstractGameAgent

    # data -
    agentMemorySize::Int64
    agentStrategyCacheSize::Int64
    agentStrategyArray::Array{PQBasicMinorityGameKitStrategy,1}

    # default constructor -
    PQBasicMinorityGameKitAgent() = new()
end

mutable struct PQBasicMinorityGameKitWorld <: PQAbstractGameWorld

    # data -
    gameAgentArray::Array{PQAbstractGameAgent,1}
    context::PQBasicMinorityGameKitSimulationContext

    # default constructor -
    PQBasicMinorityGameKitWorld() = new()
end

# Basic game types above here -------------------------------------------------------------------------- #

