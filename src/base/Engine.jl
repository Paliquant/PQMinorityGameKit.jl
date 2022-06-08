
# Basic simulation -
function _simulation(worldModel::PQBasicMinorityGameKitWorld, context::PQBasicMinorityGameKitSimulationContext)

    # initialize -
    numberOfSimulationSteps = context.numberOfSimulationSteps

    # main loop -
    for s ∈ 1:numberOfSimulationSteps
    end

end


# this method dispatches to context specific simulation impls -
function run(world::T) where T <: PQAbstractGameWorld

    # get context -
    context = world.context

    # dispacth to correct logic -
    return _simulation(world, context)
end