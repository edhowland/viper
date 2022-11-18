# test_buffer_ext.rb: tests for module BufferExt

# BufferExt is included with in class Buffer and extends some internal methods
# these are for helpful situations. E.g. the .at command should return a '' if  the @b_buf array is empty



require_relative 'test_helper'


class TestBufferExt < Minitest::Test
  def setup
    @buf = Buffer.new
    @b.extend BufferExt
  end
  def test_ok
    #
  end
  def test_at_returns_empty_string_when_buffer_empty
    assert_eq '', @buf.at
  end
end