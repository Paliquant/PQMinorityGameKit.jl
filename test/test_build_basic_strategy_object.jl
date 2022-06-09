using PQMinorityGameKit

function build_basic_strategy_object(memorySize::Int64, score::Int64)

    # setup the parameter values -
    parameters = Dict{String,Any}()
    parameters["agentMemorySize"] = memorySize;
    parameters["initialStrategyScore"] = score;

    # return -
    return build(PQBasicMinorityGameKitStrategy, parameters)
end

# uncomment me to run test alone -
# so = build_basic_strategy_object(5);