# delete_tests.rb - tests for  delete stuff in class Buffer

require_relative 'test_helper'



class DeleteTests < MiniTest::Test
  def setup
    @buf = Buffer.new
  end
  def test_empty_is_true_when_buffer_empty
    assert @buf.empty?
  end
  def test_empty_false_when_not_empty
    @buf.ins 'thing'
    assert_false @buf.empty?
  end
  def test_front_start_is_0_in_empty_buffer
    assert_equal 0, @buf.line_start
  end
  def test_line_start_line_is_0_when_many_chars_exist_but_no_line
    @buf.ins 'thing'
        assert_equal 0, @buf.line_start
  end
  def test_delete_line_w_empty_buffer
    @buf.del_line
    assert @buf.empty?
  end
  def test_line_start_finds_first_line_w_just_one_newline_char
    @buf.ins "\n"
    assert_equal 1, @buf.line_start
  end
  def test_line_start_finds_next_char_line_when_has_space_newline_space
    @buf.ins " \n "
    assert_equal 2, @buf.line_start
  end
  def test_finds_true_start_of_line_w_in_middle
    @buf.ins "0123\n5678\n012"
    @buf.goto_position 6
    assert_equal 5, @buf.line_start
  end

  def test_line_end_0_for_empty_buf
    assert_equal 0, @buf.line_end
  end

  def test_line_end_eob_with_no_lines_but_nonempty
    @buf.ins "thing"
    assert_equal 5, @buf.line_end
  end

  def test_line_end_on_2nd_line
    @buf.ins "\nhello\n"
    @buf.beg; @buf.fwd
    assert_equal 1, @buf.line_start
    assert_equal 6, @buf.line_end
  end
  # del_line tests
  def test_del_line_actually_removes_line
#    skip
    @buf.ins 'thing'
    assert_equal false, @buf.empty?
    @buf.del_line
    assert_equal 0, @buf.length
    assert_equal true, @buf.empty?
  end
end