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
end
