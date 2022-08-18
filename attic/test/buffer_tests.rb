# buffer_test.rb - class BufferTest - tests for class Buffer
require_relative 'test_helper'

class BufferTests < BaseSpike
  def set_up
    @buffer = Buffer.new ''
  end

  def test_config_ok
    assert_is @buffer, Buffer
  end
  
  def test_buffer_resolves_to_itself
    @buffer = Buffer.new 'abcd'
    assert_equals @buffer.to_s, 'abcd'
  end
  def test_insert
    @buffer.ins 'the quick brown fox'
    assert_equals @buffer.to_s, 'the quick brown fox'
  end
  def test_del_raises_exception
    assert_raises RuntimeError do 
      @buffer.del
    end
  end
  def test_fwd
    @buffer = Buffer.new '01234'
    @buffer.fwd
    assert_equals @buffer.at, '1'
  end
  def test_fwd_then_del
    @buffer = Buffer.new '012345'
    @buffer.fwd
    @buffer.del
    assert_equals @buffer.to_s, '12345'
  end
  def test_fwd_then_ins
    @buffer = Buffer.new 'the brown fox'
    @buffer.fwd; @buffer.fwd; @buffer.fwd; @buffer.fwd
    @buffer.ins 'quick '
    assert_eq @buffer.to_s, 'the quick brown fox'
  end
  def test_fwd_back_ins
    @buffer = Buffer.new '012345'
    @buffer.fwd; @buffer.fwd;@buffer.fwd
    assert_eq @buffer.at, '3'
    @buffer.back
    @buffer.ins 'A'
    assert_eq @buffer.to_s, '01A2345'
  end
  def test_srch_fwd
    @buffer = Buffer.new 'Now is the time for all good men to come to the aid of their country'
    @buffer.srch_fwd 'good'
    assert_eq @buffer.at, 'g'
  end
  def test_srch_fwd_non_existant
        @buffer = Buffer.new 'Now is the time for all good men to come to the aid of their country'
        @buffer.srch_fwd 'zzzyyxx'
        assert_eq @buffer.at, 'N'
  end
  def test_srch_back
        @buffer = Buffer.new 'Now is the time for all good men to come to the aid of their country'
  @buffer.fin
@buffer.srch_back 'good'
  assert_eq @buffer.at, 'g'
  end
#describe 'srch_back for non-existant regex' do
  def test_srch_back_for_nonexist_pattern
            @buffer = Buffer.new 'Now is the time for all good men to come to the aid of their country'
  @buffer.fin
  @buffer.srch_back 'xxyyzz'
  assert_nil @buffer.at
  end
#describe 'del a lot of content' do
  def test_del_a_lot_of_content
    @buffer.ins 'abcde'
    assert_eq @buffer.del('abcde'), 'abcde'
    assert_eq @buffer.to_s, ''
  end
#describe 'del_at' do
  def test_del_at
    @buffer.ins 'abcde'
    @buffer.beg
    @buffer.fwd
    assert_eq(@buffer.del_at, 'b')
    assert_eq(@buffer.to_s, 'acde')
  end
#describe 'overwrite!' do
  def test_overwrite
    @buffer = Buffer.new 'abcde'
    @buffer.overwrite! '01234'
    assert_eq @buffer.to_s, '01234'
  end
#describe 'goto_position' do
  def test_goto_position
    @buffer = Buffer.new 'abcde'
    @buffer.goto_position 2
    assert_eq @buffer.position, 2
    assert_eq @buffer.at, 'c'
  end
#describe 'goto_position backwards' do
  def test_goto_position_backwards
    @buffer = Buffer.new 'hellow world'
    @buffer.fin
    @buffer.goto_position 5
    assert_eq @buffer.position, 5
    assert_eq @buffer.at, 'w'
  end

#describe 'word_back' do
  def test_word_back
    @buffer = Buffer.new "ABCD\n  EFGH"
    @buffer.fin
    assert_eq @buffer.word_back, "EFGH"
  end
#describe 'rchomp string w/o beginning newline' do
  def test_rchomp_without_beginning_newline
    string = 'hello'
    assert_eq @buffer.rchomp(string), string
  end
#describe 'rchomp with leading newline' do
  def test_rchomp_with_leading_newline
    string = "\nhello"
    assert_eq @buffer.rchomp(string), 'hello'
  end
#describe 'look_ahead' do
  def test_look_ahead
    @buffer = Buffer.new "line 1\nline \nline 3\nline 4\n"
    assert_not_empty @buffer.look_ahead
  end
#describe 'clear' do
  def test_clear
    @buffer = Buffer.new 'hello world'
    @buffer.clear
    assert_empty @buffer.to_s
  end
#describe 'line_number' do
  def test_line_number
    @buffer = Buffer.new "\n\n\n\n\n"
    @buffer.down; @buffer.down
    assert_eq @buffer.line_number, 3
  end
#describe 'word_fwd' do
  def test_word_fwd
    @buffer = Buffer.new 'hello world'
    assert_eq @buffer.word_fwd, 'hello'
  end
#describe 'word_fwd - no match' do
  def test_word_fwd_no_match
    assert_nil @buffer.word_fwd
  end

#describe 'eob? front is false' do
  def test_eob_front_is_false
    @buffer = Buffer.new 'hello world'
    assert_false @buffer.eob?
  end
#describe 'eob? after move to end' do
  def test_eob_after_fin_is_true
    @buffer = Buffer.new 'hello world'
    @buffer.fin
    assert @buffer.eob?
  end

#describe 'indent_level' do
  def test_indent_level
    @buffer = Buffer.new '  Jq something'
    assert_eq @buffer.indent_level, 2
  end
#describe 'empty line indent_level is 0' do
  def test_empty_line_indent_level_is_0
    assert_eq @buffer.indent_level, 0
  end
#describe 'no indent_level should be 0' do
  def test_indent_level_full_string_is_0
    @buffer = Buffer.new 'hello world'
    assert_eq @buffer.indent_level, 0
  end
#describe '2 tabs should be 4 indent_level' do
  def test_2_tabs_indent_level_should_be_4
    @buffer = Buffer.new '    hello world'
    assert_eq @buffer.indent_level, 4
  end
#describe 'only spaces still report 6' do
def test_only_spaces_indent_level_should_still_be_6
@buffer = Buffer.new '      '
      assert_eq @buffer.indent_level, 6
end
  def test_lines
    @buffer.ins "line 1\nline 2\nline 3\n"
    assert_eq @buffer.lines.length, 3
  end
  def test_mismatched_buffers_are_not_equal
    b1 = Buffer.new 'hello'
    b2 = Buffer.new 'hell'
    assert_neq b1, b2
  end
  def test_buffers_with_exact_same_contents_are_equal
    b1 = Buffer.new 'hello'
    b2 = Buffer.new 'hello'
    assert_eq b1, b2
  end
  def test_clones_are_equal
    b1 = Buffer.new 'hello'
    b2 = b1.clone
    assert_eq b1, b2
  end
  def test_clones_are_not_the_exact_same_object
    b1 = Buffer.new 'hello'
    b2 = b1.clone
    assert_neq b1.object_id, b2.object_id
  end
  def test_up_raises_buffer_exceeded_when_at_top
    b = Buffer.new "line 1\nline 2\n"
    assert_raises BufferExceeded do
      b.up
    end
    def test_down_raises_buffer_exceeded_when_at_last_line
          b = Buffer.new "line 1\nline 2\n"
    b.down
    assert_raises BufferExceeded do
      b.down
    end
    end
  end
  def test_back_raises_buffer_exceeded_when_at_beg
    b = Buffer.new "line 1\nline 2\n"
    assert_raises BufferExceeded do
      b.back
    end
  end
  def test_fwd_raises_buffer_exceeded_when_at_end_of_buffer
    b = Buffer.new ''
    assert_raises BufferExceeded do
      b.fwd
    end
  end

  def test_length_0
    b = Buffer.new
    assert_eq 0, b.length
  end
  def test_length_5
    b = Buffer.new 'hello'
    assert_eq 5, b.length
  end
  def test_length_10_when_not_at_either_end
    b = Buffer.new
    b.ins '0123456789'
    b.back; b.back; b.back
    assert_eq 10, b.size
  end
end
