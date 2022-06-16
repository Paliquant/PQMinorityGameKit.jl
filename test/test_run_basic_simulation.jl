using PQMinorityGameKit
using DataFrames

function run_basic_simulation()

    # hardcode some data -
    numberOfAgents = 25
    numberOfSimulationSteps = 1000

    # setup the parameter values -
    world_parameters = Dict{String,Any}()
    world_parameters["numberOfSimulationSteps"] = numberOfSimulationSteps;
    world_parameters["numberOfAgents"] = numberOfAgents
    world_parameters["Sₒ"] = 1.0
    world_parameters["λ"] = 10000.0

    # initialize agent information -
    agentParametersDictArray = Array{Dict{String,Any},1}()
    for aᵢ ∈ 1:numberOfAgents
        
        # setup agent parameters -
        agent_parameters = Dict{String,Any}()
        agent_parameters["agentMemorySize"] = 6
        agent_parameters["agentStrategyCacheSize"] = 100
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
number_of_trials = 10
numberOfSimulationSteps = 1000
PA = Array{Float64,2}(undef, numberOfSimulationSteps, (number_of_trials+1))
for t ∈ 1:number_of_trials
    
    # run the simulation -
    (bws,st, wt) = run_basic_simulation()

    # copy: price data into PA -
    for s ∈ 1:numberOfSimulationSteps
        global PA[s,1] = wt[s,1]
        global PA[s,t+1] = wt[s,2]
    end
end