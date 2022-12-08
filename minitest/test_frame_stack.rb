# frame_stack_test.rb - tests for FrameStack

require_relative 'test_helper'

class FrameStackTest < MiniTest::Test
  def setup
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
  def test_rindex_of_finds_previous_frames_where_block_is_true
    fs = FrameStack.new
    fs.first[:aa] = 99
    fs.push
    fs[:aa] = 88
    fs.push
    fs[:aa] = 77
    result = fs.rindex_of {|e| e[:aa] == 88 }
    assert_eq result, 1
  end
  def test_rindex_of_returns_nil_when_nothing_matches
    fs = FrameStack.new
    fs.push
    fs.push
    fs.push
    fs[:aa] = 99
    result = fs.rindex_of {|e| e[:aa] == 0 }
    assert_nil result
  end
  def test_rindex_of_given_4_levels_deep_still_finds_correct_index
    fs = FrameStack.new
    fs.first[:aa] = 0
    fs.push
    fs[:aa] = 1
    fs.push
    fs[:aa] = 2
    fs.push
    fs[:aa] = 3
    result = fs.rindex_of {|e| e[:aa] == 2 }
    assert_eq result, 2
  end
  def test_empty_predicate
    fs = FrameStack.new
    assert(!fs.empty?)
  end

  # globalize: tests the globalize method. This method will merge the first
  #  hash with the top of the stack. Used in the source builtin command
  # to make sure any call to source, say within a function will expose global
  # variables at the outer level. To replicate the behaviour of Bash
  def test_globalize
    fs = FrameStack.new
    fs.first[:foo] = 9
    fs.push
    fs[:foo] = 8
    fs.push
    fs[:foo] = 7
    fs.push
    fs[:foo] = 10
    fs.globalize
    fs.pop; fs.pop; fs.pop
    assert_eq 10, fs[:foo]
    assert_eq 10, fs.first[:foo]
  end

end
