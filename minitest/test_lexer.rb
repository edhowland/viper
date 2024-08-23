# test_lexer.rb - tests for new Vish lexer


require_relative 'test_helper'

class TestLexer < MiniTest::Test
  def setup
    @lexer = nil
  end

  def start(src)
    @lexer = Lexer.new(src)
    @lexer.run
  end

  # line numbers
  def test_line_number_starts_as_1
    start "foo"

  assert_eq 1, @lexer.tokens[0].line_number
  end
  def test_line_number_increments
    start "pwd\necho fo\n"

    assert_eq 2, @lexer.tokens[2].line_number
    assert_eq 2, @lexer.tokens[2].line_number


  end

  def test_function_keywords_bare
    start 'function () { pwd }'
    assert_eq FUNCTION, @lexer.tokens[0].type


  end
  # keywords
  def test_match_no_keyword
    start 'foo'
    assert_false @lexer.keyword
  end

  def test_match_keyword_fn
    start 'fn'
    assert_eq FUNCTION, @lexer.tokens.first.type
  end
  def test_match_function
    start 'function'
    assert_eq FUNCTION, @lexer.tokens.first.type
    assert_eq 'function', @lexer.tokens.first.contents
  end
  def test_match_alias
    start 'alias '
    assert_eq ALIAS,@lexer.tokens.first.type 
  end

  # check to make sure that lexer does not double on fns because the regex matcher must be anchored at start
  def test_correctly_matches_2_functions
    start 'fn foo() { pwd };fn bar() { foo }'
    
    assert_eq FUNCTION, @lexer.tokens[0].type
    assert_eq WS, @lexer.tokens[1].type
    assert_eq FUNCTION, @lexer.tokens[12].type
  end
# check for keyword proper regex matches
def test_match_future_function_after_statement
  start "pwd\nfn foo() { pwd }"
  
  assert_eq BARE, @lexer.tokens[0].type
end

  # from tests on existing code base
  def test_alias_keyword_is_not_confused_with_identifier_starting_with_alias_prefix
    start 'alias_keyword foo'
      assert_neq ALIAS, @lexer.tokens.first.type
  end

  def test_function_keyword_not_to_be_confused_with_identifiers_beginningwith_string_starting_with_function
    start 'function_declaration'
    assert_neq FUNCTION, @lexer.tokens.first.type
  end

  def test_fn_keyword_not_to_be_confused_with_identifiers_beginning_with_string_starting_with_fn
    start 'fn_foo'
    assert_neq FUNCTION, @lexer.tokens.first.type
  end

  def test_bare_string_allows_for_astrix
    start '??_*.vsh'
    
  end
  def test_fn_as_an_identifier_followd_by_right_paren
    start ' fn)'
    assert_neq FUNCTION, @lexer.tokens[1].type
  end
  def test_fn_as_an_identifier_followd_by_a_comma
    start 'fn, bar)'
    assert_neq FUNCTION, @lexer.tokens.first.type
  end

  def test_bare_string_does_not_containing_rbrace
    start 'foo}'
    assert_neq 'foo}', @lexer.tokens.first.contents
  end
  # compute line numbers per each instance of Lexer
  def test_2_lexers_have_different_line_numbers
    start "foo\nbar\nbaz\n"
    l2 = Lexer.new("spam\nquo\n")
    l2.run
    assert_eq 3, l2.tokens[3].line_number
  end
end
