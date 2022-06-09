using PQMinorityGameKit
using Test

# include my test files -
include("./test_build_basic_strategy_object.jl")

# -- Model creation tests ------------------------------------------------------ #
function run_default_test() 
    return true
end
# ------------------------------------------------------------------------------- #

function run_basic_agent_strategy_build_test()

    # build a strategy object
    m = 5
    strategy_object = build_basic_strategy_object(m);

    # get the strategy -
    strategy_dict = strategy_object.strategy;

    # is strategy_dict the correct size?
    if (length(strategy_dict) == (2^m))
        return true
    end

    # default: always false -
    return false
end

@testset "default_test_set" begin
    @test run_default_test() == true
    @test run_basic_agent_strategy_build_test() == true
end