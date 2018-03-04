# test_span.rb - tests forSpan

require_relative 'test_helper'

class TestSpan < BaseSpike
  def set_up
    @sp = Span.new 0..9
  end
  def test_first_is_0
    assert@sp.first.zero?
  end
  def test_last_is_9
    assert_eq @sp.last, 9
  end
  # add 2 spans
  def test_adding_2_spans_is_one_span_from_first_of_left_to_last_of_right
    l = Span.new 0..4
    r = Span.new 6..9
    c = l + r
    assert c.first.zero?
  end
  def test_last_after_addition_is_9_of_right_term
    l = Span.new 0..4
    r = Span.new 6..9
    c = l + r
    assert_eq c.last, 9
  end
  def test_after_subtraction_result_first_is_right_term_first
    l = Span.new 4..9
    r = Span.new 0..3
    s = l - r
    assert s.first.zero?
  end
  def test_after_subtraction_result_last_is_right_first_less_1
    l = Span.new 4..9
    r = Span.new 0..9
    s = l - r
    assert_eq s.last, 3
  end

  # test outer function
  def test_outer_returns_final_extent
    my = Span.new 4..6
    o = my.outer(@sp)
    assert_eq o.first, 7
end

  # Test EmptySpan
  def test_empty_span_subtracting_longer_span_returns_
    e = EmptySpan.new 5
    sp = Span.new 0..9
    result = e - sp
    assert_eq result.range, 0..4
  end
  # For inserting at end of buffer, insertion point is length of buffer, or 10 here
  def test_empty_span_at_right_edge
    e=EmptySpan.new 10
    result = e - @sp
    assert_eq result.range, 0..9
  end
  def test_empty_span_outer_calculates_correct_span
    e = EmptySpan.new 5
    result = e.outer(@sp)
    assert_eq result.range, 5..9
  end


  # Test LeftSpan - left outer edge of a slice
  def test_left_span_returns_empty_after_subtract
    ls = LeftSpan.new
    result = ls - @sp
    assert result.range, ls.range
  end
  def left_edge_outer_returns_original_span
    ls = LeftSpan.new
    result = ls.outer(@sp)
    assert_eq result.range, @sp.range
  end

  # Test Right edge - for insertion at end of buffer
  def test_right_edge_returns_itself_after_subtraction
    rs = RightSpan.new 10
    result = rs.outer(@sp)
    assert_eq result.range, rs.range
  end
  def test_right_edge_outer_returns_itself
    rs = RightSpan.new 10
    result = rs.outer(@sp)
    assert_eq result.range, rs.range
  end

  # test spaceship operator: <=>
  def test_left_span_less_than_right_span
    lsp = Span.new 0..3
    rsp = Span.new 7..9
    assert_eq lsp <=> rsp, -1
  end
  def test_2_spans_are_equal_and_return_0
    lsp = Span.new 4..6
    rsp =  Span.new(lsp.range)
    assert lsp.<=>(rsp).zero?
  end
  def test_right_span_is_greater_than_left_span
    lsp = Span.new 0..3
    rsp = Span.new 7..9
    assert_eq rsp <=> lsp, 1
  end

  # test for overlap?
  def test_non_overlapping_spans_return_false
    assert_false Span.new(0..3).overlap?(Span.new(7..9))
  end
  def test_reversed_non_overlapping_is_stil_false
    assert_false Span.new(7..9).overlap?(Span.new(0..3))
  end
  def test_overlapping_smaller_for_larger_returns_true_on_boundary
    assert Span.new(0..6).overlap?(Span.new(6..9))
  end
  def test_span_completewithin_outer_span
    assert Span.new(5..6).overlap?(Span.new(3..9))
  end
  def test_other_span_is_totally_left_of_self
    assert_false Span.new(5..9).overlap?(Span.new(0..3))
  end
  def test_last_edge_touches_self_first_is_true
    assert Span.new(5..9).overlap?(Span.new(0..5))
  end
  end
