# test_lexer.rb - tests for new Vish lexer


require_relative 'test_helper'

class TestLexer < MiniTest::Test
  def start(src)
    lex src
    lx_run
  end
  # line numbers
  def test_line_number_starts_as_1
    start "foo"

  assert_eq 1, $tokens[0].line_number
  end
  def test_line_number_increments
    start "pwd\necho fo\n"

    assert_eq 2, $tokens[2].line_number
  end

  def test_function_keywords_bare
    start 'function () { pwd }'
    assert_eq FUNCTION, $tokens[0].type
  end
end
