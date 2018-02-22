# test_pt.rb - tests for PieceTable

require_relative 'test_helper'



class TestPieceTable < BaseSpike
  def set_up
    @pt = PieceTable.new '0123ABC789'
  end
  def test_to_s_is_orginal
    assert_eq @pt.orig, @pt.to_s
  end
  def test_delete_results_in_3_fewer_chars
    @pt.delete 4, 3
    assert_eq @pt.to_s.length, 7
  end
  def test_delete_has_the_orig_with_3_less_chars
    @pt.delete 4, 3
    assert_eq @pt.to_s, '0123789'
  end
  def test_insert_has_3_more_chars
    @pt.insert 'def', offset: 7
    assert_eq @pt.to_s.length, 13
  end
  def test_insert_has_those_new_3_chars
    @pt.insert 'def', offset: 7
    assert_eq @pt.to_s, '0123ABCdef789'
  end
end