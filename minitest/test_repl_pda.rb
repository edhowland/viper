# test_repl_pda.rb: Tests the multi-line trigger finite state machine: 
# push-down automata


require_relative 'test_helper'


class TestReplPDA < Minitest::Test
  def setup
    @pda = ReplPDA.new
  end
  def test_ok
    assert_false @pda.error?
  end
  def test_empty_string_returns_true
    assert @pda.run('')
    assert_false @pda.error?
  end
  def test_string_with_no_any_type_of_bracket_nor_quotes_returns_true
    assert @pda.run('echo foo | cat dog')
    assert_false @pda.error?
  end
  def test_one_left_brace_returns_false
  assert_false @pda.run('{')
    assert_false @pda.error?
  end
  def test_left_bracket_returns_false
    assert_false @pda.run('[')
    assert_false @pda.error?
  end
  def test_left_paren_returns_false
    assert_false @pda.run('(')
    assert_false @pda.error?
  end
  def test_single_quote_returns_false
    assert_false @pda.run("'")
    assert_false @pda.error?
  end
  def test_double_quote_returns_false
    assert_false @pda.run('"')
    assert_false @pda.error?
  end
  def test_right_brace_returns_error
    @pda.run('}')
    assert @pda.error?
  end
  def test_right_bracket_returns_error
    @pda.run(']')
    assert @pda.error?
  end
  def test_right_paren_returns_error
    @pda.run(')')
    assert @pda.error?
  end
  # Now test ballanced pairs: '{}', '()', '[]'
  def test_balanced_braces_returns_true
    assert @pda.run('{}')
    assert_false @pda.error?
  end
  def test_balanced_brackets_return_true
    assert @pda.run('[]')
    assert_false @pda.error?
  end
  def test_balanced_parens_return_true
    assert @pda.run('()')
    assert_false @pda.error?
  end
  def test_space_lbrace_space_space_rbrace_is_true
    assert @pda.run(' {  } ')
    assert_false @pda.error?
  end
  def test_single_quotes_within_balanced_double_quotes_is_true
    assert @pda.run("  \"  '  \"  ")
    assert_false @pda.error?
  end
  def test_embedded_double_quotes_inside_balanced_single_quotes_is_true
    assert @pda.run('   \'  "  \'  ')
    assert_false @pda.error?
  end
  def test_one_single_quote_returns_false
    assert_false @pda.run("foo 'bar")
    assert_false @pda.error?
  end
  def test_one_double_quote_returns_false
    assert_false @pda.run('blah "    ')
    assert_false @pda.error?
  end
end