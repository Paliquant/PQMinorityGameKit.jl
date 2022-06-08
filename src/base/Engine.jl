
# Basic simulation -
function _simulation(world::PQBasicMinorityGameKitWorld, context::PQBasicMinorityGameKitSimulationContext)::Dict{Int64,DataFrame}

    # initialize -
    numberOfSimulationSteps = context.numberOfSimulationSteps
    agentArray = world.agentArray
    simulationStateArchive = Dict{Int64,DataFrame}()

    # main loop -
    for s ∈ 1:numberOfSimulationSteps
    end


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