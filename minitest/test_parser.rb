# test_parser.rb - tests for Hal - chdir, virtual?, others

require_relative 'test_helper'

class TestParser < MiniTest::Test
  def start(src)
    lex src
    lx_run

    p_init
    strip_whitespace
  end


  def test_empty
    start ''
    x = p_statement_list
    assert x.empty?
  end

  def test_one_command
    start 'pwd'
    x = p_statement_list
    assert_eq 1, x.length
  end

  def test_two_commands_using_newline
    start "pwd\necho"
    x = p_statement_list
    assert_eq 2, x.length
  end

  def test_three_commands_with_newlines_trailing_newline
    start "pwd\necho\ndate\n"
    x = p_statement_list
    assert_eq 3, x.length
  end

  def test_two_commands_with_semicolons
    start 'foo;baz'
    x = p_statement_list
    assert_eq 2, x.length
  end

  # compound source with both newlines and semicolons
  def test_both_newlines_and_colons
    start "pwd;echo\ncd;pwd"
    x = p_statement_list
    assert_eq 4, x.length
  end

  # argument parsing stuff
  def test_arg_list_empty
    start ''
    assert p_arg_list.empty?
  end

  def test_one_argument
    start 'foo'
    assert_eq 1, p_arg_list.length
  end

  def test_2_args
    start 'arg1 arg2'
    assert_eq 2, p_arg_list.length
  end


  def test_multiple_args
    start 'foo bar baz arg4 arg5'
    assert_eq 5, p_arg_list.length
  end

  # start to combine commands with (possibly empty) argument lists
  def test_command
    start 'echo'
    assert_eq 1, p_command.length
      end

  def test_command_stores_string
    start 'pwd'
    assert_eq 'pwd', p_command.first.to_s
  end
  def test_command_properly_returns_false
    start "\n"
    assert_false p_command
    assert_eq 0, $p_tok
  end


  def test_command_with_one_argument
    start 'echo foo'
    x = p_statement
    assert_eq 1, x.length
  end

  def test_command_with_multiple_arguments_is_single_statement
    start 'echo foo bar baz arg4 arg5'
    assert_eq 1, p_statement.length
  end

  def test_statement_actually_hasmultiple_arguments_within
    start 'mkdir /var/foo /xxx/yyy/ just_in_time'
    s = p_statement
    assert_eq 4, s.first.context.length
    
  end


  def test_multiple_statements_where_one_has_one_argument
    start 'cd /foo/bar;pwd'
    x = p_statement_list;
    assert_eq 2, x.length
  end
end
