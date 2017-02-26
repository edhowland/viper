# deref_test.rb - class DerefTest - tests for Deref

require_relative 'test_helper'

class DerefTest < BaseSpike
  def set_up
    @frames = FrameStack.new
    # Must set :ifs to single space for Deref.call split
    @frames[:ifs] = ' '
  end
  def test_init
    var = Deref.new 'key'
    assert_is var, Deref
    assert_eq var.key, 'key'
    assert_eq var.value, ''
  end
  def test_call_returns_value_in_frames
    @frames[:key] = 'hello'
    var = Deref.new :key
    result = var.call frames:@frames
    assert !result.nil?, 'Expected result from Deref.call to not be nil, but was nil'
    assert_eq result, 'hello'
  end
  def test_range
    @frames[:range] = '0..3'
    var = Deref.new :range
    result = var.call frames:@frames
    assert_is result, Array
    assert_eq result, ['0', '1', '2', '3']
  end
end
