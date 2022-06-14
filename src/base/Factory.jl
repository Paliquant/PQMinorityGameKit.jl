function _design(n::Int64)

    # initialize -
    bitStringArray = Array{String,1}()

    # build the bit strings -
    for i = 0:((2^n) - 1)
        stmp = bitstring(i)
        value = stmp[end - n + 1:end]
        push!(bitStringArray, value)
    end

    # return -
    return bitStringArray
end

function build(contextType::Type{T}, 
    parameters::Dict{String,Any})::PQAbstractGameSimulationContext where T <: PQAbstractGameSimulationContext 

    # initialize -
    model = eval(Meta.parse("$(contextType)()")) # empty agent model -

    # for the rest of the fields, let's lookup in the dictionary.
    # error state: if the dictionary is missing a value -
    for field_name_symbol ∈ fieldnames(contextType)
        
        # convert the field_name_symbol to a string -
        field_name_string = string(field_name_symbol)
        
        # check the for the key -
        if (haskey(parameters,field_name_string) == false)
            throw(ArgumentError("dictionary is missing: $(field_name_string)"))    
        end

        # get the value -
        value = parameters[field_name_string]

        # set -
        setproperty!(model,field_name_symbol,value)
    end

    # return -
    return model
end

function build(worldType::Type{PQBasicMinorityGameKitWorld}, 
    parameters::Dict{String,Any})::PQBasicMinorityGameKitWorld

    # build an empty world -
    world = eval(Meta.parse("$(worldType)()"))
    agentArray = Array{PQBasicMinorityGameKitAgent,1}()

    # configure the world -
    numberOfAgents = get!(parameters, "numberOfAgents",25) # default: 25 agents 
    numberOfSimulationSteps = get!(parameters, "numberOfSimulationSteps",25) # default: 25 agents 
    Sₒ = get!(parameters, "Sₒ", 1.0)
    λ = get!(parameters, "λ", 10.0)

    # setup the context -> for a basic simulation, we use
    contextParameters = Dict{String,Any}()
    contextParameters["numberOfSimulationSteps"] = numberOfSimulationSteps
    contextParameters["Sₒ"] = Sₒ
    contextParameters["λ"] = λ
    world.context = build(PQBasicMinorityGameKitSimulationContext, contextParameters)

    # build agentArray -
    if (haskey(parameters, "agentParametersDictArray") == true)

        # we have an array of parameters for each agent -
        agentParametersDictArray = parameters["agentParametersDictArray"]
        for a ∈ 1:numberOfAgents
            agent = build(PQBasicMinorityGameKitAgent, agentParametersDictArray[a])
            push!(agentArray, agent)
        end
    else

        # empty -
        empty_dict =  Dict{String,Any}()

        # ok: don't have parameters for the agents, use all default values -
        for _ ∈ 1:numberOfAgents
            agent = build(PQBasicMinorityGameKitAgent, empty_dict)
            push!(agentArray, agent)
        end
    end

    # setup the world -
    world.numberOfAgents = numberOfAgents
    world.gameAgentArray = agentArray

    # return -
    return world
end

function build(agentType::Type{PQBasicMinorityGameKitAgent}, 
    parameters::Dict{String,Any})::PQBasicMinorityGameKitAgent

    # build an empty basic game agent -
    agent = eval(Meta.parse("$(agentType)()"))

    # get stuff from the parameters dict -
    m = get!(parameters,"agentMemorySize",3)            # default: 3 
    n = get!(parameters,"agentStrategyCacheSize",10)    # default: 10
    a = get!(parameters,"initialAgentScore",0)          # default: 0

    # set agent dimensions -
    agent.agentMemorySize = m
    agent.agentStrategyCacheSize = n
    agent.score = a
    
    # build strategy array -
    strategyArray = Array{PQBasicMinorityGameKitStrategy,1}(undef, n)
    for i ∈ 1:n
        
        strategyOptions = Dict{String,Any}()
        strategyOptions["agentMemorySize"] = m
        strategyOptions["initialStrategyScore"] = 0
        strategyArray[i] = build(PQBasicMinorityGameKitStrategy, strategyOptions)
    end
    agent.agentStrategyArray = strategyArray
        
    # return -
    return agent 
end

function build(strategyType::Type{PQBasicMinorityGameKitStrategy}, 
    parameters::Dict{String,Any})::PQBasicMinorityGameKitStrategy

    # initialize -
    strategyObject = eval(Meta.parse("$(strategyType)()")) # empty agent model -
    strategy = Dict{String,Int64}()

    # get data from parameters -
    m = get!(parameters, "agentMemorySize", 3)          # default: mem size = 3
    s = get!(parameters,"initialStrategyScore", 0)      # default: random 
    
    # compute the array of keys -
    keys = _design(m)
    for i ∈ 1:(2^m)
        
        # generate a key value pair - 
        key =  keys[i]

        # capture this entry -
        strategy[key] = rand([-1,1])
    end

    # setup the strategyObject -
    strategyObject.strategy = strategy
    strategyObject.score = s 

    # return -
    return strategyObject
end