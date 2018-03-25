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

  # return sensible for moves past some boundary, like up past top, bottom
  # if down past bottom
  def test_down_past_bottom_returns_bottom
    bot = @gq.bottom
    @gq.up
    @gq.down
    @gq.down
    assert_eq @gq.down, bot
  end
  def test_up_returns_top_if_already_at_first_line
    @gq.right; @gq.right
    top = Span.new(0..0)
    assert_eq @gq.up, top
  end

  # limit stuff
  def test_limit_is
    assert_eq @gq.limit, 27
  end

  # search stuff
  # word searches
  def test_word_
      sp = @gq.word
    assert_eq sp, Span.new(0..4)
  end
  def test_word_fwd
    assert_eq @gq.word_fwd, Span.new(5..6)
  end
end
