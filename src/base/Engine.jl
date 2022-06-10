
# Basic simulation -
function _choice(buffer::Array{Int64,1}, agent::PQBasicMinorityGameKitAgent)::Tuple{Int64, Int64}

    # big picture: compute the key
    agentStrategyArray = agent.agentStrategyArray
    n = length(agentStrategyArray)
    m = agent.memorySize
    game_array = last(buffer,m)

    # convert this to binary (-1 => 0)
    binary_game_array = replace(x->x==-1 ? x=0 : x=1, game_array)

    # what Int does this correspond to?
    key = ""
    for i ∈ 1:m
        key*="$(binary_game_array[i])"
    end

    # which strategy should we select?
    tmp_score_array = Array{Int64,1}(n)
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
    total_action = sum(actions)

    # what action did this agent take?
    my_action = actions[agentIndex,1]             # first col is the action that I chose -
    my_strategy_index = actions[agentIndex,2]     # second col is the index of the strategy that I picked
    my_payoff = -1*my_action*sign(total_action)

    # update the agent score -
    current_score = agent.score
    new_score = current_score + my_payoff
    agent.score = new_score

    # update the strategy score -
    winner = sign(total_action)
    if (winner == my_action)
        
        # Yes! I was a winner 
        agent.agentStrategyArray[my_strategy_index].score += 1 # update the score, this was the best -
    end

    # return -
    return agent
end

function _simulation(world::PQBasicMinorityGameKitWorld, 
    context::PQBasicMinorityGameKitSimulationContext)::Dict{Int64,DataFrame}

    # initialize -
    total_action = 0
    numberOfSimulationSteps = context.numberOfSimulationSteps
    agentArray = world.agentArray
    numberOfAgents = world.numberOfAgents
    simulationStateArchive = Dict{Int64,DataFrame}()
    agentChoiceArray = Array{Int64,2}(numberOfAgents,2)
    winnerArray = Array{Int64,1}(numberOfSimulationSteps)
    
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

    # main loop -
    for sᵢ ∈ 1:numberOfSimulationSteps
        
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
            a = agentArray[aᵢ]
            agentArray[aᵢ] = _update(aᵢ, agentChoiceArray, a) 
        end
        
        # ok, so we need to update the gameBuffer -
        tmp = gameBuffer[2:end]
        for j ∈ 1:(m-1)
            gameBuffer[j] = tmp[j]
        end        
        gameBuffer[m] = rand(-1:1)

        # What are we going to capture at each time step?
        # ...

        # capture the current winner -
        total_action = sum(agentChoiceArray)
        winnerArray[sᵢ] = sign(total_action)

    end

    # package the results 
    # ...

    # return -
    return simulationStateArchive
end


# this method dispatches to context specific simulation impls -
function run(world::T)::Dict{Int64,DataFrame} where T <: PQAbstractGameWorld

    # get context -
    context = world.context

    # dispacth to correct logic -
    return _simulation(world, context)
end