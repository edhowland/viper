# closure_tests.rb - tests for 

require_relative 'test_helper'

class ClosureTests < BaseSpike
  def set_up
    @fs = FrameStack.new
    @fs.first[:level] = 0
  end
  def pushit
    nl = @fs.top[:level] + 1
        @fs.push
        @fs[:level] = nl
  end
  def makeit type
    @fs[:__FUNCTION_TYPE__] = type
  end
  def test_no_outer_function_or_lambda_returns_empty
    assert_empty Closure.close(@fs)
  end
  def test_function_returns_its_index_frame
#    skip
    @fs.push
    @fs.push
    @fs.top[:__FUNCTION_TYPE__] = 'function'
    @fs.push
    fr = Closure.close(@fs)
    assert_eq fr, @fs.frames[-2..-1]
  end
  def test_floor_returns_0_when_no_function
    assert_eq Closure.floor(@fs), BFN::Max
  end
  def test_ceil_returns_0_when_no_outer_lambda
    assert_eq Closure.ceil(@fs), BFN::Max
  end
  def test_closed_predicate_returns_false_for_both_maxs
    assert_false Closure.closed?(BFN::Max, BFN::Max)
  end
  def test_closed_predicate_returns_false_when_all_0_parms
    assert_false Closure.closed?(0, 0)
  end
  def test_closed_predicate_returns_true_when_one_parm_is_1
    assert Closure.closed?(BFN::Max, 1)
  end
  def test_closed_predicate_returns_true_when_first_parm_is_2
    assert Closure.closed?(2, BFN::Max)
  end
  def test_closed_predicate_returns_false_when_strange_conditition_both_parms_are_0
    assert_false Closure.closed?(0, 0)
  end
  def test_closed_predicate_returns_true_when_first_parm_is_1_and_parm_2_is_3
    assert Closure.closed?(1, 3)
  end
  def test_close_over_function_and_2_lambdas_internally
    @fs.push
    @fs[:__FUNCTION_TYPE__] = 'function'
    @fs.push
    @fs[:__FUNCTION_TYPE__] = 'lambda'
    @fs.push
        @fs[:__FUNCTION_TYPE__] = 'lambda'
    fr = Closure.close(@fs)
    assert_eq fr.length, 3
  end
  def test_multi_levels_of_functions_and_lambdas_do_the_right_thing
    pushit
    makeit 'lambda'
    pushit
    makeit 'function'
    pushit
    makeit 'lambda'
                fr = Closure.close(@fs)
    assert_eq fr[0][:level], 2
    assert_eq fr[-1][:level], 3
  end
  def test_just_a_bunch_of_lambdas
    pushit
    makeit 'lambda'
    pushit
    makeit 'lambda'
    pushit
    makeit 'lambda'
    fr = Closure.close(@fs)
    assert_eq fr[0][:level], 1
  end
  def test_a_bunch_of_functions_only_finds_innermost
    pushit
    makeit 'function'
    pushit
    makeit 'function'
    pushit
    makeit 'function'
    fr = Closure.close @fs
    assert_eq fr[0][:level], 3
  end
end
