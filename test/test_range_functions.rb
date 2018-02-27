# test_range_functions.rb - tests for Range functions

require_relative 'test_helper'


class TestRangeFunctions < BaseSpike
  def test_split_returns_2_ranges
    a,b = split_range(0..9, 2, 3)
    assert_is a, Range
    assert_is b, Range
  end
  def test_split_range_returns_2_equal_length_ranges
    a, b = split_range(0..9, 5, 0)
    assert_eq a.to_a.length, 5
    assert_eq b.to_a.length, 5
  end
  def test_can_split_range_into_2_equal_halves
    a, b = split_range(0..9, 4, 0)
    assert_eq a, 0..3
  end
  def test_2nd_halve_is_equal_rest_of_range
    a,b = split_range(0..9, 5, 0)
    assert_eq b, 5..9
  end
  def test_splits_with_3_0
    a, b = split_range(0..9, 3, 0)
    assert_eq a, 0..2
    assert_eq b, 3..9
  end
  def test_split_w_near_end
    a, b  = split_range(0..9, 8, 0)
    assert_eq a, 0..7
    assert_eq b, 8..9
  end
  def test_near_left_edge
    a, b  = split_range(0..9, 1, 0)
    assert_eq a, 0..0
    assert_eq b, 1..9
  end
  def test_w_longer_initial_range
    a, b = split_range(0..15, 10, 0)
    assert_eq a, 0..9
    assert_eq b, 10..15
  end
  # test for ranges not starting at 0
  def test_range_gt_starting_0
    a, b = split_range(5..14, 10, 0)
    assert_eq a, 5..9
    assert_eq b, 10..14
  end

  # test for different lengths > 0 for delete functions
  def test_split_range_with_3_length_first_is_upto_offset
    a, b  = split_range(0..9, 4, 3)
    assert_eq a, 0..3
  end
  def test_range_split_w_4_3_second_is_rest_less_length_3
        a, b  = split_range(0..9, 4, 3)
  assert_eq b, 7..9
  end

  # tests for range comparison offsets
  # Given the logical range: 0..9
  # and the append buffer concrete range: 5..9
  # And the logical offset 3 within the logical range
  # return 8
  #
  def test_offset_of_given_2_ranges
    result = offset_of(5..9,6..10, 8)
    assert_eq result, 9
  end
  def test_different_ranges_and_offset
    result = offset_of(0..9, 0..4, 3)
    assert_eq result, 3
  end

  # test join ranges for undo actions
  def test_join_range_restores_origanl
    range = 0..9
    l, r = split_range(range, 5,0)
    assert_eq join_range(l, r), range
  end
  def test_join_range_w_larger_beginning_spot
    range = 9..100
    l, r = split_range(range, 59, 0)
    assert_eq join_range(l, r), range
  end
  def test_join_range_with_hole_from_delete
    range = 0..9
    l, r = split_range(range, 4, 3)
        assert_eq join_range(l, r), range
  end
  def test_join_range_w_larger_start_and_large_hole
    range = 100..999
    l, r = split_range(range, 101, 997)
        assert_eq join_range(l, r), range
  end

  # test split of 0 length range
  def test_split_range_returns_2_0_length_ranges
    l,r = split_range(0..0, 0, 0)
    assert_eq l, 0..0
assert_eq r, 0..0
  end
end