using PQMinorityGameKit

function build_basic_game_world_object(numberOfAgents::Int64, numberOfSimulationSteps::Int64)

    # setup the parameter values -
    parameters = Dict{String,Any}()
    parameters["numberOfAgents"] = numberOfAgents
    parameters["numberOfSimulationSteps"] = numberOfSimulationSteps

    # return -
    return build(PQBasicMinorityGameKitWorld, parameters)
end

# uncomment me to run test alone -
gwo = build_basic_game_world_object(10,100);