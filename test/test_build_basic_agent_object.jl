using PQMinorityGameKit

function build_basic_agent_object(memorySize::Int64, cache::Int64, score::Int64)

    # setup the parameter values -
    parameters = Dict{String,Any}()
    parameters["agentMemorySize"] = memorySize;
    parameters["initialStrategyScore"] = score;
    parameters["agentStrategyCacheSize"] = cache;

    # return -
    return build(PQBasicMinorityGameKitAgent, parameters)
end

# uncomment me to run test on its own ...
# ao = build_basic_agent_object(5,10,0)