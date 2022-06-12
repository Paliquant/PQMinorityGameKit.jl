using PQMinorityGameKit
using DataFrames

function run_basic_simulation()

    # hardcode some data -
    numberOfAgents = 25
    numberOfSimulationSteps = 100

    # setup the parameter values -
    world_parameters = Dict{String,Any}()
    world_parameters["numberOfSimulationSteps"] = numberOfSimulationSteps;
    world_parameters["numberOfAgents"] = numberOfAgents

    # initialize agent information -
    agentParametersDictArray = Array{Dict{String,Any},1}()
    for aᵢ ∈ 1:numberOfAgents
        
        # setup agent parameters -
        agent_parameters = Dict{String,Any}()
        agent_parameters["agentMemorySize"] = 5
        agent_parameters["agentStrategyCacheSize"] = 10
        agent_parameters["initialStrategyScore"] = 0
        agent_parameters["initialAgentScore"] = 0
        push!(agentParametersDictArray,agent_parameters)
    end
    world_parameters["agentParametersDictArray"] = agentParametersDictArray


    # build the world -
    gwo = build(PQBasicMinorityGameKitWorld, world_parameters)

    # run -
    return simulation(gwo)
end

# uncomment me to run standalone test -
bws = run_basic_simulation()