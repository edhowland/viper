# test_slice_table.rb - tests forSliceTable

require_relative 'test_helper'

class TestSliceTable < BaseSpike
  def set_up
    @source = '0123456789'
    @st = SliceTable.new @source
  end
  def test_slice_table_identity_w_source
    assert_eq @st.to_s, @source
  end
  def test_empty_span_splits_clean_left_is_5
    @st.split_at(EmptySpan.new(5))
        assert_eq @st.to_s, @source
  end
  def test_split_w_gap_in_middle
    @st.split_at(Span.new(4..6))
    assert_eq @st.to_s, '0123789'
  end
  def test_split_at_left_edge
    @st.split_at(Span.new(0..4))
    assert_eq @st.to_s, '56789'
  end
  def test_split_at_right_edge_is_left_bound
    @st.split_at(Span.new(5..9))
    assert_eq @st.to_s, '01234'
  end
end
