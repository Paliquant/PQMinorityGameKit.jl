using PQMinorityGameKit
using Test

# include my test files -
include("./test_build_basic_strategy_object.jl")
include("./test_build_basic_agent_object.jl")

# -- Model creation tests ------------------------------------------------------ #
function run_default_test() 
    return true
end
# ------------------------------------------------------------------------------- #

function run_basic_agent_strategy_build_test()

    # build a strategy object
    m = 5
    s = 0
    strategy_object = build_basic_strategy_object(m,s);

    # get the strategy -
    strategy_dict = strategy_object.strategy;

    # is strategy_dict the correct size?
    if (length(strategy_dict) == (2^m))
        return true
    end

    # default: always false -
    return false
end

function run_basic_agent_object_build_test()

    # build a strategy object
    m = 5
    s = 0
    c = 10
    a = build_basic_agent_object(m,c,s)
    local_test_results = Array{Bool,1}()

    # test: is the strategy array the correct size?
    strategy_array = a.agentStrategyArray
    if (length(strategy_array) == c)
        push!(local_test_results, true)
    else
        push!(local_test_results, false)
    end

    # test: pick a strategy - is the strategy the correct size?
    first_strategy = first(strategy_array)

    # is strategy_dict the correct size?
    if (length(first_strategy.strategy) == (2^m))
        push!(local_test_results, true)
    else
        push!(local_test_results, false)
    end

    # test: is the score == 0?
    last_strategy = last(strategy_array)
    if (last_strategy.score == s)
        push!(local_test_results, true)
    else
        push!(local_test_results, false)
    end

    # ok: do we have local tests that are false?
    if (all(i->i==true,local_test_results) == true)
        return true
    end

    # default: always false -
    return false
end

@testset "default_test_set" begin
    @test run_default_test() == true
    @test run_basic_agent_strategy_build_test() == true
    @test run_basic_agent_object_build_test() == true
end