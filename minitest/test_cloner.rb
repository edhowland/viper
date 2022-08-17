# cloner_tests.rb - tests for 

require_relative 'test_helper'

class ClonerTests < MiniTest::Test
  def test_calls_clone
    m = MiniTest::Mock.new
    m.expect :clone, true
    b2 = cloner m
    m.verify
  end
  def test_calls_under_line_clone
    m = MiniTest::Mock.new
    #m.wont :clone
    m.expect :_clone, true
    b1 = cloner m
    m.verify
  end
  def test_calls_deep_clone_first
    m = MiniTest::Mock.new
    m.expect :deep_clone, true
    b1 = cloner(m)
    m.verify
  end
  def test_will_call_dunder_clone
    m = MiniTest::Mock.new
    m.expect :_clone, true
    b1 = cloner m
    m.verify
  end
end
