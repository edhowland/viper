# test_parser.rb - tests fornew Vish parser

require_relative 'test_helper'

class TestParser < MiniTest::Test
  def start(src)
    lex src
    lx_run

    p_init
  end

  # parser util functions
  def test_expect_matches_and_returns_empty_array
    start ';'
    t = expect(SEMICOLON).()
    assert_eq Array, t.class
    assert t.empty?
  end

  def test_expect_is_false_if_no_match
    start ':'
        t = expect(SEMICOLON).()
    assert_false t
  end

  def test_consume_returnsarray_of_token_contents_if_matches
    start 'foo'
    t = consume(BARE).()
    assert_eq Array, t.class
    assert_eq 1, t.length
    assert_eq 'foo', t.first
  end

  def test_consume_returns_false_ifno_match
    start ':'
    t = consume(BARE).()
    assert_false t
  end

  # alt with consume should return correct match
  def test_alt_with_3_choices_and_no_matches_should_return_false
    start ':'
    t = p_alt(consume(BARE), consume(SEMICOLON), consume(EQUALS))
    assert_false t
  end

  def test_alt_with_middle_match_returns_it
    start ':'
    t = p_alt(consume(SEMICOLON), consume(COLON), consume(BARE))
    assert t
    assert_eq Array, t.class
    assert_eq 1, t.length
    assert_eq ':', t.first
  end

  def test_seq_with_all_fails_returns_false
    start 'echo foo bar'
    t = p_all(consume(COLON), consume(EQUALS), consume(SEMICOLON))
    assert_false t
  end

  # testing grammar rule functions
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
    assert_eq 1, p_command.call().length
      end

  def test_command_stores_string
    start 'pwd'
    assert_eq 'pwd', p_command.call().first.to_s
  end
  def test_command_properly_returns_false
    start "\n"
    assert_false p_command.call()
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
  # working with comments
  def test_comment_line_by_itself_between_2_commands
    start "pwd\n# this is a comment\necho foo\n"
    sl = p_statement_list
    assert_eq 2, sl.length
  end


  def test_comment_trails_command_after_some_whitespace
    start "pwd\necho foo  \t# this is a comment\n"
    sl = p_statement_list
    assert_eq 2, sl.length
  end
  # compound tests of statement lists
  def test_compound_with_leading_newlines_and_comments
    start <<-EOD
    
      # a comment
      pwd
      
      
      echo foo # trailing comment
    EOD
    sl = p_statement_list
    assert_eq 2, sl.length
  end

  def test_assignment_semicolon_command
    start 'foo=baz; pwd'
    t = p_statement_list
    assert_eq Statement, t[0].class
    assert_eq Statement, t[1].class
  end

  def test_command_newline_assignment
    start "pwd  \n  abc=10  "
    t = p_statement_list
    assert_eq Statement, t[0].class
    assert_eq Statement, t[1].class    
  end
  
  # line number preserving
  def test_statement_preserves_line_numbers_from_token_stream
    start "pwd;echo foo\ncd foo\n"
    
    sl = p_statement_list
    assert_eq 1, sl[0].line_number
    assert_eq 1, sl[1].line_number
    assert_eq 2, sl[2].line_number
  end
  # function declarations
  def test_parameter_list_is_empty
    start ''
    assert p_parameter_list.empty?
  end
  def test_parameter_list_has_1_symbol
    start 'foo'
    t = p_parameter_list
    assert_eq 1, t.length
    assert_eq :foo, t.first
  end

  def test_parameter_list_has_3_symbols
    start 'a, b, c'
    t = p_parameter_list
    assert_eq 3, t.length
    assert_eq [:a, :b, :c], t
  end
  # function decl
  def test_function_w_no_params
    start 'function foo() { pwd }'
    
    x = p_function
    assert_eq FunctionDeclaration, x.class
    assert x.args.empty?
    assert_eq 1, x.block.statement_list.length
  end


  def test_function_decl_has_3_arguments_all_symbols
    start 'function bar(a, b, c) { pwd }'
    
    x = p_function;
    assert_eq 3, x.args.length
    assert x.args.reduce(true) {|i, j| i && (j.class == Symbol) }
  end
end
