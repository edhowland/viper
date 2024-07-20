# test_parser.rb - tests for Hal - chdir, virtual?, others

require_relative 'test_helper'

class TestParser < MiniTest::Test
  def start(src)
    lex src
    lx_run
    
    p_init
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
end