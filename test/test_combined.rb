# test_combined - tests for combined SlicedBuffer, GridQuery

require_relative 'test_helper'


class TestCombined < BaseSpike
  def set_up
    @source = "[line 1\n hello world\n]"
    @b = SlicedBuffer.new(@source)
    @q = GridQuery.new(@b)
  end
  def test_outdent_line_2
    @q.down
    sp = @q.cursor
    @b.delete_at(sp)
    assert_eq @b.to_s, "[line 1\nhello world\n]"
  end
end