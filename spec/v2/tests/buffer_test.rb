# buffer_test.rb - class BufferTest - tests for class Buffer
require_relative 'test_helper'

class BufferTest < BaseSpike
  def set_up
    @buffer = Buffer.new ''
  end

  def test_config_ok
    assert_is @buffer, Buffer
  end
  
  def test_buffer_resolves_to_itself
    @buffer = Buffer.new 'abcd'
    assert_equals @buffer.to_s, 'abcd'
  end
end
