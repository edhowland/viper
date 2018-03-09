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

  def test_length_0_2_is_3
    assert_eq Span.new(0..2).length, 3
  end
  def test_length_of_sp_is_10
    assert_eq @sp.length, 10
  end
  def test_length_of_single_range_4_4_is_0
    assert_eq Span.new(4..4).length, 1
  end

  # test from_{right,left}
  def test_from_right_w_len_5
    assert_eq @sp.from_right(5).range, 0..4
  end
  def test_from_left_w_5_is_5_9
    assert_eq @sp.from_left(5).range, 5..9
  end

  # test overlap
  def test_overlap_0_4_w_2_6
    left = Span.new 0..4
    right = Span.new 2..6
    assert left.overlap(right).range, 2..4
  end
  def test_complete_overlap_returns_left_span
    assert_is @sp.from_right(10), LeftSpan
  end
  def test_from_left_with_complete_overlap_returns_right_span_with_last_correct
    rs = @sp.from_left(10)
        assert_is rs, RightSpan
  end
  def test_from_left_w_overlap_length_has_correct_first
    rs = @sp.from_left(@sp.length)
    assert_eq rs.first, @sp.first
  end
  def test_from_left_w_overlap_length_has_matching_last
        rs = @sp.from_left(@sp.length)
    assert_eq rs.last, @sp.last
  end

  # equality
  def test_equality_is_true
    x = Span.new @sp.first..@sp.last
    assert x == @sp
  end
  def test_inequality_is_false
    x = @sp.from_left 4
    assert_false x == @sp
  end
  def test_less_than_is_true
    x = @sp.from_left 2
    assert @sp < x
  end
  def test_greater_than_is_true
    x = Span.new (100)..(900)
    assert x > @sp
  end

  # contains?
  def test_contains_is_true
    assert @sp.contains?(Span.new(2..4))
  end
  def test_overlaps_but_not_contained
    assert_false @sp.contains?(Span.new(2..14))
  end
  def test_not_contained_left_not_overlapping_is_false_for_contains
    assert_false Span.new(0..3).contains?(Span.new(5..9))
  end
  def test_right_outer_non_overlapping_does_not_contain
    assert_false @sp.contains?(Span.new(99..100))
  end
  def test_contains_where_exactly_equal
    x = Span.new @sp.first..@sp.last
    assert @sp.contains?(x)
  end

  # shiftl
  def test_shiftl_2
    s = Span.new 5..7
    assert_eq s.shiftl(2), Span.new(3..5)
  end
  # translate gap given other range
  def test_translate_range_6_7_given_5_8_to_1_2
    x = Span.new 0..4
    r = Span.new 5..9
    gap = Span.new 6..7
    assert_eq x.translate(r, gap), Span.new(1..2)
  end
  def test_left_gap_touches_range_left
    x = Span.new 0..4
    r = Span.new 5..9
    gap = Span.new 5..6
    assert_eq x.translate(r,gap), Span.new(0..1) 
  end
end
