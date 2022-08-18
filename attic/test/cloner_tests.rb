# cloner_tests.rb - tests for 

require_relative 'test_helper'

class ClonerTests < BaseSpike
  def test_calls_clone
    m = Mock.new
    m.expect :clone
    b2 = cloner m
    m.verify!
  end
  def test_calls_under_line_clone
    m = Mock.new
    m.wont :clone
    m.expect :_clone
    b1 = cloner m
    m.verify!
  end
  def test_calls_deep_clone_first
    m = Mock.new
    m.expect :deep_clone
    b1 = cloner(m)
    m.verify!
  end
end
