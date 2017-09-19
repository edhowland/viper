# frame_stack_test.rb - tests for FrameStack

require_relative 'test_helper'

class FrameStackTest < BaseSpike
  def set_up
    @fs = FrameStack.new
  end
  def test_merge_when_empty
    @fs.merge
  end
  def test_merge_after_push
    @fs.push
    @fs.merge
  end
  def test_object_can_be_proc
    @fs[:pr] = ->() { 11 }
    assert_eq @fs[:pr], 11
  end
  def test_object_is_not_a_proc
    @fs[:xx] = 'xx'
    assert_eq 'xx', @fs[:xx]
  end
  def test_top_equal_takes_hash
    @fs.push
    @fs.top = {}
  end
  def test_flatten_returns_empty_array_w_empty_hash
    fs=FrameStack.new
    f = fs.flatten
    assert_eq f, {}
  end
  def test_flatten_returns_identity_of_single_key
    fs = FrameStack.new
    fs[:aa] = 99
    f = fs.flatten
    assert_eq f[:aa], 99
  end

  def test_after_push_value_holds_most_recent_value
    fs = FrameStack.new
    fs[:aa] = 11
    fs.push
    fs[:aa] = 99
    f = fs.flatten
    assert_eq f[:aa], 99
  end
  def test_index_of_returns_nil_if_no_block
    fs=FrameStack.new
    idx = fs.index_of
    assert_nil idx
  end
  def test_index_of_returns_0_for_found_object_for_which_block_is_true
    fs=FrameStack.new
    fs[:aa] = 99
    idx = fs.index_of {|e| e[:aa] == 99 }
    assert_eq idx, 0
  end
  def test_index_of_finds_index_of_second_when_3_levels_but_2_matches
    fs=FrameStack.new
    fs.push
    fs[:aa] = true
    fs.push
    fs.push
    fs[:aa] = true
    idx = fs.index_of {|e| e[:aa] }
    assert_eq idx, 1
  end
  def test_delete_works
    fs = FrameStack.new
    fs[:aa] = :bb
    assert_eq fs[:aa], :bb
    fs.delete :aa
    assert_eq fs[:aa], ''
  end
  def test_delete_with_2_levels
    fs = FrameStack.new
    fs[:aa] = :bb
    fs.push
    fs[:aa] = :cc
    assert_eq fs[:aa], :cc
    fs.delete :aa
        assert_eq fs[:aa], ''
  end
end
