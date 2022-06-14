
# Basic simulation -
function _choice(buffer::Array{Int64,1}, agent::PQBasicMinorityGameKitAgent)::Tuple{Int64, Int64}

    # big picture: compute the key
    agentStrategyArray = agent.agentStrategyArray
    n = length(agentStrategyArray)
    m = agent.agentMemorySize
    game_array = last(buffer,m)

    # convert this to binary (-1 => 0)
    binary_game_array = replace(x->x==-1 ? x=0 : x=1, game_array)

    # what Int does this correspond to?
    key = ""
    for i ∈ 1:m
        key*="$(binary_game_array[i])"
    end

    # which strategy should we select?
    tmp_score_array = Array{Int64,1}(undef, n)
    for i ∈ 1:n
        tmp_score_array[i] = agentStrategyArray[i].score
    end
    best_strategy_index = argmax(tmp_score_array)

    # get the strategy -
    best_strategy = agentStrategyArray[best_strategy_index].strategy

    # return the proposed move -
    return (best_strategy[key], best_strategy_index)
end

function _update(agentIndex::Int64, actions::Array{Int64,2}, 
    agent::PQBasicMinorityGameKitAgent)::PQBasicMinorityGameKitAgent

    # First: compute the total action -
    total_action = sum(actions[:,1])

    # what action did this agent take?
    my_action = actions[agentIndex, 1]             # first col is the action that I chose -
    my_strategy_index = actions[agentIndex, 2]     # second col is the index of the strategy that I picked
    
    # update the strategy score -
    winner = sign(total_action)
    if (winner == my_action)

        # update the agent score -
        current_score = agent.score
        new_score = current_score + 1
        agent.score = new_score
        
        # get old score -
        old_score = agent.agentStrategyArray[my_strategy_index].score
        new_score = old_score + 1
        agent.agentStrategyArray[my_strategy_index].score = new_score
       
    else 

        # update the agent score -
        current_score = agent.score
        new_score = current_score - 1
        agent.score = new_score

        # this strategy was a looser. Vote down. 
        old_score = agent.agentStrategyArray[my_strategy_index].score
        new_score = old_score - 1
        agent.agentStrategyArray[my_strategy_index].score = new_score
    end

    # return -
    return agent
end

function _simulation(world::PQBasicMinorityGameKitWorld, 
    context::PQBasicMinorityGameKitSimulationContext)

    # initialize -
    numberOfSimulationSteps = context.numberOfSimulationSteps
    Sₒ = context.Sₒ
    λ = context.λ
    agentArray = world.gameAgentArray
    numberOfAgents = world.numberOfAgents
    agentChoiceArray = Array{Int64,2}(undef, numberOfAgents, 2)
    winnerArray = Array{Int64,1}(undef, numberOfSimulationSteps)

    # initialize the price array -
    asset_price_array = Array{Float64,1}(undef,numberOfSimulationSteps+1)
    asset_price_array[1] = Sₒ

    # output -
    simulationStateArchive = Dict{Int64,DataFrame}()
    simulationStrategyArchive = Dict{Int64,DataFrame}()
    
    # what is the longest memory for an agent?
    # we need to have the game have tghis size of memory - 
    tmp = Array{Int64,1}()
    for a ∈ 1:numberOfAgents
        push!(tmp, agentArray[a].agentMemorySize)
    end
    gameMemorySize = agentArray[argmax(tmp)].agentMemorySize

    # initialize the game buffer with random values -
    gameBuffer = Array{Int64,1}(undef, gameMemorySize)
    for i ∈ 1:gameMemorySize
        gameBuffer[i] = rand([-1,1])
    end

    # initialize the world table -
    world_table = DataFrame(
        time = Int64[],
        price = Float64[]
    );

    # main loop -
    for sᵢ ∈ 1:numberOfSimulationSteps

        # capture the world state -
        world_state_tuple = (
            time = sᵢ,
            price = asset_price_array[sᵢ]
        );
        push!(world_table, world_state_tuple)

        # setup agent table -
        agent_table = DataFrame(
            winner = Array{Int64,1}(),
            choice = Array{Int64,1}(),
            strategy = Array{Int64,1}(),
            score = Array{Int64,1}(),
            memory = Array{Int64,1}(),
            cache = Array{Int64,1}()
        );
        
        # setup the strategy table -
        strategy_table = DataFrame(
            agentid = Int64[],
            strategyid = Int64[],
            table = Dict{String,Int}(),
            score = Int64[]
        );  

        # we have the gameBuffer, let all the agents look at the buffer, and make thier choice -
        for aᵢ ∈ 1:numberOfAgents
            
            # get the agent -
            a = agentArray[aᵢ]

            # what choice does this agent make?
            (choice, best_strategy_index) = _choice(gameBuffer, a)

            # the choice is the first col, the strategy index that gave me that choice is in col 2
            agentChoiceArray[aᵢ,1] = choice
            agentChoiceArray[aᵢ,2] = best_strategy_index
        end
    
        # update the individual agents given the collective behavior -
        for aᵢ ∈ 1:numberOfAgents
            old_a = agentArray[aᵢ]
            new_a = _update(aᵢ, agentChoiceArray, old_a)
            agentArray[aᵢ] =  new_a
        end
    
        # capture the data from the current time step -
        winnerArray[sᵢ] = sign(sum(agentChoiceArray[:,1]))
        for aᵢ ∈ 1:numberOfAgents
        
            results_tuple = (
                winner = winnerArray[sᵢ],
                choice = agentChoiceArray[aᵢ,1],
                strategy = agentChoiceArray[aᵢ,2],
                score = agentArray[aᵢ].score,
                memory = agentArray[aᵢ].agentMemorySize,
                cache = agentArray[aᵢ].agentStrategyCacheSize
            );
            push!(agent_table, results_tuple)

            # for this agent, grab the strategy -
            strategyArray = agentArray[aᵢ].agentStrategyArray
            n = length(strategyArray)
            for j ∈ 1:n
                
                # get the strategy -
                strategy = strategyArray[j]
                
                # what score does this strategy have?
                s = strategy.score

                # build the results tuple -
                results_tuple_strategy = (
                    agentid = aᵢ,
                    strategyid = j,
                    score = s,
                    table = strategy.strategy
                );
                push!(strategy_table, results_tuple_strategy)
            end
        end
        simulationStateArchive[sᵢ] = agent_table
        simulationStrategyArchive[sᵢ] = strategy_table

        # ok, so we need to update the gameBuffer -
        tmp = gameBuffer[2:end]
        for j ∈ 1:(gameMemorySize-1)
            gameBuffer[j] = tmp[j]
        end        
        gameBuffer[gameMemorySize] = rand(-1:1)

        # compute the next price -
        asset_price_array[sᵢ + 1] = asset_price_array[sᵢ] + (1/λ)*sum(agentChoiceArray[:,1])
    end

    # return -
    return (simulationStateArchive, simulationStrategyArchive, world_table)
end


# this method dispatches to context specific simulation impls -
function simulation(world::T) where T <: PQAbstractGameWorld

    # get context -
    context = world.context

    # dispacth to correct logic -
    return _simulation(world, context)
end