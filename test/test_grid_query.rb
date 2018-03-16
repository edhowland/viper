# test_grid_query.rb - tests for GridQuery

require_relative 'test_helper'

class TestGridQuery < BaseSpike
  def set_up
    @source = "line 1\nline 2\nline 3\nline 4\n"
    @sb = SlicedBuffer.new @source
    @gq = GridQuery.new @sb
  end
  def test_can_get_first_line
    sp = @gq.line
    assert_eq @sb[sp], "line 1\n"
  end
  def test_move_down_gets_second_linemethod
    @gq.down
    sp = @gq.line
    assert_eq @sb[sp], "line 2\n"
  end
  def test_down_3_and_up
    3.times { @gq.down }
    @gq.up
    sp = @gq.line
    assert_eq @sb[sp], "line 3\n"
  end
  def test_right_returns_1_1
    assert_eq @gq.right, Span.new(1..1)
  end
  def test_down_then_left_isfirst_line
    @gq.down
    @gq.left
    sp = @gq.line
    assert_eq @sb[sp], "line 1\n"
  end

  # top and bottom of buffer
  def test_top_after_down
    @gq.down
    @gq.top
    assert_eq @gq.cursor, Span.new(0..0)
  end
  def test_bottom
    @gq.bottom
    @gq.up
    sp = @gq.line
    assert_eq @sb[sp], "line 3\n"
  end

  # start of line/end of line methods
  def test_right_right_then_sol
    @gq.right; @gq.right
    @gq.sol
    assert_eq @gq.cursor, Span.new(0..0)
  end
  def test_2_down_then_3_right_then_sol
    2.times { @gq.down }
    3.times { @gq.right }
    sp = @gq.line

    @gq.sol
    assert_eq @gq.cursor, Span.new(sp.first..sp.first)
  end
  def test_eol_points_to_newline
    sp = @gq.eol
    assert_eq @sb[sp], "\n"
  end
  def test_bottom_sol_then_eol
    @gq.bottom
    @gq.sol
    sp = @gq.line
    @gq.eol
    assert_eq @gq.cursor, Span.new(sp.last..sp.last)
  end
end
