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
  # keywords
  def test_match_no_keyword
    lex 'foo'
    assert_false lx_keyword
  end

  def test_match_keyword_fn
    lex 'fn'
    assert_eq FUNCTION, lx_keyword().type
  end
  def test_match_function
    lex 'function'
    x = lx_keyword
    assert_eq FUNCTION, x.type
    assert_eq 'function', x.contents
  end
  def test_match_alias
    lex 'alias'
    x = lx_keyword
    assert_eq ALIAS, x.type
    assert_eq 'alias', x.contents
  end

  # check to make sure that lexer does not double on fns because the regex matcher must be anchored at start
  def test_correctly_matches_2_functions
    start 'fn foo() { pwd };fn bar() { foo }'
    
    assert_eq FUNCTION, $tokens[0].type
    assert_eq WS, $tokens[1].type
    assert_eq FUNCTION, $tokens[12].type
  end
# check for keyword proper regex matches
def test_match_future_function_after_statement
  start "pwd\nfn foo() { pwd }"
  
  assert_eq BARE, $tokens[0].type
end

end
