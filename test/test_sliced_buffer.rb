# buffer test_sliced_buffer.rb - tests for SlicedBuffer

require_relative 'test_helper'


class TestSlicedBuffer < BaseSpike
  def set_up
    @source = 'hello world'
    @sb = SlicedBuffer.new @source
  end
  def test_can_recover_original_string
    assert_eq @sb.to_s, @source
  end
  def test_can_delete_middle_space
    @sb.delete_at(5)
    assert_eq @sb.to_s, 'helloworld'
  end
  def test_delete_larger_range
    @sb.delete_at(1..3)
    assert_eq @sb.to_s, 'ho world'
  end

  # insertion
  def test_insert_between_words
    @sb.insert(5, ' there')
    assert_eq @sb.to_s, 'hello there world'
  end
  def test_can_delete_then_insert
    @sb.delete_at(5)
    @sb.insert(7, 'abc')
    assert_eq @sb.to_s, 'hellowoabcrld'
  end

  # test undo/redo
  def _test_first_attempt_to_undo_raises_underflow
    assert_raises UndoStackUnderflowError do
      @sb.undo
    end
  end
  def test_first_attempt_to_redo_raises_redo_overflow
    assert_raises RedoStackOverflowError do
      @sb.redo
    end
  end
  def test_can_undo_one_delete
    @sb.delete_at 5
    @sb.undo
    assert_eq @sb.to_s, @source
  end
  def test_can_undo_3_changes
    @sb.insert 5, ' there '
    @sb.delete_at 5..12
    @sb.insert 5, ' great big wonderful '
    @sb.undo; @sb.undo; @sb.undo
    assert_eq @sb.to_s, @source
  end
  def test_can_redo_3_times_after_3_undos
    @sb.insert 5, ' there '
    @sb.delete_at 5..12
    @sb.insert 5, ' great big wonderful '
    @sb.undo; @sb.undo; @sb.undo
    @sb.redo; @sb.redo; @sb.redo
    assert_eq @sb.to_s, 'hello great big wonderful world'
  end

  # test append
  def test_can_append
    string = "\nthis is fun\n"
    @sb << string
    assert_eq @sb.to_s, @source +string 
  end
  def test_can_append_3_strings
    s1 = '0123456789'
    s2 = s1 * 2
    s3 = s1 * 3
    @sb << s1; @sb << s2; @sb << s3
    assert_eq @sb.to_s, @source + s1 + s2 + s3 
  end
  def test_can_append_twice_then_delete_somethings
    @sb << '01234'; @sb << '56789'
    @sb.delete_at @source.length + 5
    assert_eq @sb.to_s.length, @source.length + 10 - 1
  end

  # query method
  def test_can_query_within_stuff_of_buffer
    assert_eq @sb[0], 'h'
  end
  def test_can_reach_last_char
    offset = @sb.to_s.length - 1
    assert_eq @sb[offset], 'd'
  end
  def test_can_query_entire_string
    offset = @source.length - 1
    assert_eq @sb[0..offset], @source
  end
  def test_can_query_part_of_string
    assert_eq @sb[4..7], @source[4..7]
  end
  def test_query_still_holds_after_delete
    @sb.delete_at(4..6)
    ch = @source.chars
    # We have to delete at start of range, because its shifts left after each one
    (4..6).each do |e|
      ch.delete_at(4)
    end
    source = ch.join

    assert_eq @sb[0..6], source[0..6]
  end
  def test_can_query_after_insert
    @sb.insert 5, ' there '
    offset = @sb.to_s.length - 1
    assert_eq @sb[0..offset], @sb.to_s
  end
  def test_can_query_after_insert_then_delete
    @sb.insert 5, ' another '
    @sb.delete_at 6..14

    assert_eq @sb[0..10], @source
  end
end
