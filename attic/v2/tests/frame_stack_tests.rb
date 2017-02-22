# frame_stack_test.rb - tests for FrameStack

require_relative 'test_helper'

class FrameStackTest < BaseSpike
  def set_up
    @fs = FrameStack.new
  end
  def test_merge_when_empty
    @fs.merge
  end
  def test_merge_after_push
    @fs.push
    @fs.merge
  end
end