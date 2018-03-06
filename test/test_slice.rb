# test_slice.rb - tests for

require_relative 'test_helper'

class TestSlice < BaseSpike
  def set_up
  @source = '0123456789'
    @sl = Slice.new @source
  end
  def test_to_s_is_the_same_as_source
    assert_eq @sl.to_s, @source
  end
  def test_shorter_slice_of_source
    sl = Slice.new @source, Span.new(0..5)
    assert_eq sl.to_s, '012345'
  end
  def test_join_2_gapped_substring_slices_into_original_source
    l = Slice.new @source, Span.new(0..4)
    r = Slice.new @source, Span.new(6..9)
    a = l.join(r)
    assert_eq a.to_s, @source
  end
  def test_join_2_ungapped_sub_slices_into_original_stringmethod
    l = Slice.new @source, Span.new(0..4)
    r = Slice.new @source, Span.new(5..9)
    a = l.join(r)
    assert_eq a.to_s, @source
  end
  def test_split_w_3_gap_is_2_gapped_slices
    l, r = @sl.split Span.new(4..6)
    assert_eq l.to_s, '0123'
  end
  def test_after_split_right_result_is_7_8_9 
    l, r = @sl.split Span.new(4..6)
    assert_eq r.to_s, '789'
  end
  def test_split_0_length_span
    l,r = @sl.split Span.new(5..0)
    assert_eq l.to_s, '01234'
  end
  def test_split_ungapped_is_2_halves_right_term_is_second_halve
    l,r = @sl.split EmptySpan.new(5)

    assert_eq r.to_s, '56789'
  end
  # terst for outer edge and internal splits
  def test_split_at_left_edge
    ls = LeftSpan.new
    l,r  = @sl.split ls
    assert_eq l.to_s, ''
  end
  def test_left_edge_right_is_original_slice
    ls = LeftSpan.new
    l,r  = @sl.split ls
    assert_eq r.to_s, @sl.to_s
  end
  def test_right_edge_left_is_original_string
   rs = RightSpan.new 10
   l,r = @sl.split rs
   assert_eq l.to_s, @sl.to_s
  end
  def test_right_edge_right_after_split_is_empty_string
       rs = RightSpan.new 10
   l,r = @sl.split rs
   assert r.to_s.empty?
  end

  # with_span: New Slice with new slice
  def test_with_span_2_6
    sl = @sl.with_span Span.new(2..6)
    assert_eq sl.to_s, '23456'
  end
  def test_with_span_left_outer_edge
    sl = @sl.with_span Span.new(0..4)
    assert_eq sl.to_s, '01234'
  end
  def test_with_span_right_outer_edge
    sl =  @sl.with_span Span.new(6..9)
    assert_eq sl.to_s, '6789'
  end
end
