abstract type PQAbstractGameAgent end
abstract type PQAbstractGameWorld end


mutable struct PQBasicMinorityGameKitAgent <: PQAbstractGameAgent

    # data -
    agentMemorySize::Int64

    # default constructor -
    PQBasicMinorityGameKitAgent() = new()
end

mutable struct PQBasicMinorityGameKitWorld <: PQAbstractGameWorld

    # data -
    gameAgentArray::Array{PQAbstractGameAgent,1}

    # default constructor -
    PQBasicMinorityGameKitWorld() = new()
end

