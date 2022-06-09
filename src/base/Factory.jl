function build(agentType::Type{T}, parameters::Dict{String,Any})::PQAbstractGameAgent where T <: PQAbstractGameAgent

    # initialize -
    model = eval(Meta.parse("$(agentType)()")) # empty agent model -

    # for the rest of the fields, let's lookup in the dictionary.
    # error state: if the dictionary is missing a value -
    for field_name_symbol ∈ fieldnames(agentType)
        
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

function build(agentType::Type{PQBasicMinorityGameKitAgent}, 
    parameters::Dict{String,Any})::PQBasicMinorityGameKitAgent

    # build an empty basic game agent -
    agent = eval(Meta.parse("$(agentType)()"))

    # get stuff from the parameters dict -
    m = get!(parameters,"agentMemorySize",3)            # default: 3 
    n = get!(parameters,"agentStrategyCacheSize",10)        # default: 10
    s = get!(parameters,"initialStrategyScore",0)       # default: 0

    # set agent dimensions -
    agent.agentMemorySize = m
    agent.agentStrategyCacheSize = n
    
    # build strategy array -
    strategyArray = Array{PQBasicMinorityGameKitStrategy,1}(undef, n)
    strategyOptions = Dict{String,Any}()
    strategyOptions["agentMemorySize"] = m
    strategyOptions["initialStrategyScore"] = s
    for i ∈ 1:n
        strategyArray[i] = build(PQBasicMinorityGameKitStrategy,strategyOptions)
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
    s = get!(parameters,"initialStrategyScore", 0)      # default: score = 0
    
    # build up the strategy dictionary -
    for i ∈ 1:(2^m)

        # generate a key value pair - 
        key =  Base.bin(UInt8(i), (2^m), false)

        # capture this entry -
        strategy[key] = rand([-1,1])
    end

    # setup the strategyObject -
    strategyObject.strategy = strategy
    strategyObject.score = s 

    # return -
    return strategyObject
end