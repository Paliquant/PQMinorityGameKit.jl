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
    Sₒ::Float64     # initial share price 
    λ::Float64      # liqudity parameter

    # default constructor -
    PQBasicMinorityGameKitSimulationContext() = new()
end

mutable struct PQBasicMinorityGameKitAgent <: PQAbstractGameAgent

    # data -
    score::Int64
    agentMemorySize::Int64
    agentStrategyCacheSize::Int64
    agentStrategyArray::Array{PQBasicMinorityGameKitStrategy,1}

    # default constructor -
    PQBasicMinorityGameKitAgent() = new()
end

mutable struct PQBasicMinorityGameKitWorld <: PQAbstractGameWorld

    # data -
    numberOfAgents::Int64
    gameAgentArray::Array{PQBasicMinorityGameKitAgent,1}
    context::PQBasicMinorityGameKitSimulationContext

    # default constructor -
    PQBasicMinorityGameKitWorld() = new()
end

# Basic game types above here -------------------------------------------------------------------------- #

