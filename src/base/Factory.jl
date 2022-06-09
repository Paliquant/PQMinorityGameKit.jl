function build(agentType::Type{T}, parameters::Dict{String,Any})::PQAbstractGameAgent where T <: PQAbstractGameAgent

    # initialize -
    model = eval(Meta.parse("$(agentType)()")) # empty agent model -

    # for the rest of the fields, let's lookup in the dictionary.
    # error state: if the dictionary is missing a value -
    for field_name_symbol ∈ fieldnames(agentType)
        
        # convert the field_name_symbol to a string -
        field_name_string = string(field_name_symbol)
        
        # check the for the key -
        if (haskey(options,field_name_string) == false)
            throw(ArgumentError("dictionary is missing: $(field_name_string)"))    
        end

        # get the value -
        value = options[field_name_string]

        # set -
        setproperty!(model,field_name_symbol,value)
    end

    # return -
    return model
end

function build(strategyType::Type{PQBasicMinorityGameKitStrategy}, 
    parameters::Dict{String,Any})::PQBasicMinorityGameKitStrategy

    # initialize -
    strategyObject = eval(Meta.parse("$(strategyType)()")) # empty agent model -
    strategy = Dict{String,Int64}()

    # get data from parameters -
    m = get!(parameters, "agentMemorySize", 3);
    
    # build up the strategy dictionary -
    for i ∈ 1:(2^m)

        # generate a key value pair - 
        key =  Base.bin(UInt8(i), (2^m), false)

        # capture this entry -
        strategy[key] = rand([-1,1])
    end

    # setup the strategyObject -
    strategyObject.strategy = strategy

    # return -
    return strategyObject
end