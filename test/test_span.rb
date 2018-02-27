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

  end
