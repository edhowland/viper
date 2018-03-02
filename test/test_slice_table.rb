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

  # test join stuff
  def test_join_previous_split_retains_integrity
    @st.split_at(EmptySpan.new(5))
    @st.join(0, 1)
    assert_eq @st.to_s, @source
  end
  def test_join_after_split_w_gap_restores_original_contetnts
    @st.split_at(Span.new(4..6))
    @st.join(0,1)
    assert_eq @st.to_s, @source
  end
  def test_left_edge_stills_joins_ok
    @st.split_at(Span.new(0..4))
    @st.join(0,1)
    assert_eq @st.to_s, @source
  end
  def test_split_at_right_edge_joins_cleanly_back
    @st.split_at(Span.new(5..9))
        @st.join(0,1)
    assert_eq @st.to_s, @source
  end
end
