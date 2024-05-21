# test_piped.rb: tests for lib/bin/piped.rb. Not a command, but used by other commands

require_relative 'test_helper'


class TestPiped < MiniTest::Test
  def test_piped_new_does_not_remove_any_args_when_no_dash
    a = ['foo', 'bar', 'baz']

    assert_equal 3, a.length
  end
  def test_piped_does_remove_dash_arg_when_present
    a = ["foo", "-", "bar"]

    Piped.new a
    assert_equal 2, a.length
  end
  def test_actual_arg_of_dash_is_removed_when_present
    a = ["foo", "-", "bar", "baz"]

    Piped.new a
    assert_equal ["foo", "bar", "baz"], a
  end
  def test_piped_question_mark_is_not_true_when_dash_isnt_present
    a = ["spam", "1", "3"]
    p = Piped.new a
    assert !p.piped?
  end
  def test_piped_question_is_true_whendash_is_present
    a = ["1", "2", "-"]
    p = Piped.new a
    assert p.piped?
  end
end