# test_pt.rb - tests for PieceTable

require_relative 'test_helper'



class TestPieceTable < BaseSpike
  def set_up
    @source = '0123ABC789'
    @pt = PieceTable.new @source 
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
  def test_can_find_descript_within_range
    ndx = @pt.within 4, 3
    assert_eq ndx, 0
  end

  # test within
  def test_within_for_orig_string
    assert_eq @pt.within(5,2), 0
  end
  def test_after_insert_finds_2nd_entry_in_table
    @pt.insert '___', offset:5
    assert_eq @pt.within(6,1), 1
  end
  # test for multiple deletes in a row
  def test_can_perform_2_deletes
    @pt.delete 4,3
    @pt.delete 1,2
    assert_eq @pt.to_s.length, 5
  end
  def test_perform_2_deletes_results_in_shorter_string_w_chars_removed
    @pt.delete 4, 3
    @pt.delete 1,2
    assert_eq @pt.to_s, '03789'
  end

  def test_insert_followed_by_delete
    len = @pt.to_s.length
    @pt.insert 'def', offset: 7
    @pt.delete 4, 3
    assert_eq @pt.to_s.length, len
  end
  def test_different_insert_followed_by_delete_results_in_changed_string
    @pt.insert 'food', offset: 4
    @pt.delete 6, 2
    assert_eq @pt.to_s, '0123foABC789'
  end

  # test if buffer is at start, before any edits, or after all reversals have been completed
  def test_start_of_table_is_true_when_beginning
    assert @pt.at_start?
  end
  def test_at_start_false_after_1_deleteion
    @pt.delete 4,3
    assert_false @pt.at_start?
  end

  # test undo actions
  def test_can_restore_original_after_delete
    meth, *args = @pt.delete(4, 3)
    @pt.send(meth, *args)
    assert_eq @pt.to_s, @source
  end
  def test_is_at_at_start_after_undo
    meth, *args = @pt.delete(1,8)
    @pt.send meth, *args
    assert @pt.at_start?
  end
  def test_can_undo_2_sequential_deletes
    d1 = @pt.delete(5,2)
    d2 = @pt.delete(1,5)
    [d2, d1].each do |d|
      meth, *args = d
      @pt.send meth, *args
    end
    assert_eq @pt.to_s, @source
  end
  def test_after_3_deletes_and_3_undos_still_at_start
    d1 = @pt.delete(5,1)
    d2 = @pt.delete(4,1)
    d3 = @pt.delete(6,1)
    [d3, d2, d1].each do |d|
      meth, *args = d
      @pt.send meth, *args
    end
    assert @pt.at_start?
    assert_eq @pt.to_s, @source
  end
  # redo some undone deletes
  def test_redo_1_undo
    u = @pt.delete 5,2
    interim = @pt.to_s
    meth, *args = u
    r =  @pt.send meth, *args
    meth, *args = r
    @pt.send meth, *args
    assert_eq @pt.to_s, interim
  end

  # test undo insert
  def test_undo_insert_one_time_is_at_start_after_undo
    meth, * args = @pt.insert '___', offset: 4
    @pt.send meth, *args
    assert @pt.at_start?
  end
  def test_after_undo_insert_buffer_is_restored
        meth, * args = @pt.insert '___', offset: 4
    @pt.send meth, *args#
    assert_eq @pt.to_s, @source
  end
  def test_after_first_delete_then_insert_every_step_preserved_after_2_undo_actions
    ud = @pt.delete 4, 3
    interim = @pt.to_s
    ui = @pt.insert('___', offset:4)
    meth, *args = ui
    @pt.send meth, *args
    assert_eq @pt.to_s, interim
    meth, *args = ud
    @pt.send meth, *args
    assert @pt.at_start?
    assert_eq @pt.to_s, @source
  end

  # delete and undelete entire buffer
  def test_delete_entire_buffer_and_undo_this_delete
    len = @pt.to_s.length
    ud = @pt.delete 0, len
    assert_empty @pt.to_s
    meth, *args = ud
    @pt.send meth, *args
    assert_eq @pt.to_s, @source
  end
  # insert at start
  def test_can_insert_at_start
    @pt.insert 'XXX', offset: 0
    assert_eq @pt.to_s, 'XXX' + @source
  end
  # test inserting on an empty buffer
  def test_can_insert_to_empty_buffer
    pt = PieceTable.new ''
    pt.insert 'hello', offset: 0
  end
end