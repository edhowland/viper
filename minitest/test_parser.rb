# test_parser.rb - tests  Vish parser

require_relative 'test_helper'

class TestParser < MiniTest::Test
  def setup
    @lexer = nil
  end

  def start(src)
    @parser = VishParser.new(src)
    @parser.setup
  end

  # run the full parser, expects a Block to result and that is returned, else assertion fails
  def full(src)
    start(src)
    b = @parser.p_root
    assert_eq Block, b.class
    b
  end

  # parser util functions
  def test_expect_matches_and_returns_empty_array
    start ';'
    t = @parser.expect(SEMICOLON).()
    assert_eq Array, t.class
    assert t.empty?
  end

  def test_expect_is_false_if_no_match
    start ':'
        t = @parser.expect(SEMICOLON).()
    assert_false t
  end

  def test_consume_returnsarray_of_token_contents_if_matches
    start 'foo'
    t = @parser.consume(BARE).()
    assert_eq Array, t.class
    assert_eq 1, t.length
    assert_eq 'foo', t.first
  end

  def test_consume_returns_false_ifno_match
    start ':'
    t = @parser.consume(BARE).()
    assert_false t
  end

  # alt with consume should return correct match
  def test_alt_with_3_choices_and_no_matches_should_return_false
    start ':'
    t = @parser.p_alt(@parser.consume(BARE), @parser.consume(SEMICOLON), @parser.consume(EQUALS))
    assert_false t
  end

  def test_alt_with_middle_match_returns_it
    start ':'
    t = @parser.p_alt(@parser.consume(SEMICOLON), @parser.consume(COLON), @parser.consume(BARE))
    assert t
    assert_eq Array, t.class
    assert_eq 1, t.length
    assert_eq ':', t.first
  end

  def test_seq_with_all_fails_returns_false
    start 'echo foo bar'
    t = @parser.p_all(@parser.consume(COLON), @parser.consume(EQUALS), @parser.consume(SEMICOLON))
    assert_false t
  end

  # testing grammar rule functions
  def test_empty
    start ''
    x = @parser.statement_list
    assert_false x
  end

  def test_one_command
    start 'pwd'
    x = @parser.statement_list
    assert_eq 1, x.length
  end

  def test_two_commands_using_newline
    start "pwd\necho"
    x = @parser.statement_list
    assert_eq 2, x.length
  end

  def test_three_commands_with_newlines_trailing_newline
    start "pwd\necho\ndate\n"
    x = @parser.statement_list
    assert_eq 3, x.length
  end

  def test_two_commands_with_semicolons
    start 'foo;baz'
    x = @parser.statement_list
    assert_eq 2, x.length
  end

  # compound source with both newlines and semicolons
  def test_both_newlines_and_colons
    start "pwd;echo\ncd;pwd"
    x = @parser.statement_list
    assert_eq 4, x.length
  end

  # argument parsing stuff
  def test_arg_list_empty
    start ''
    assert @parser.function_args.empty?
  end

  def test_one_argument
    start 'foo'
    assert_eq 1, @parser.function_args.length
  end

  def test_2_args
    start 'arg1, arg2'
    assert_eq 2, @parser.function_args.length
  end


  def test_multiple_args
    start 'foo bar baz arg4 arg5'
    assert_eq 5, @parser.context.length
  end

  # start to combine commands with (possibly empty) argument lists


  def test_statementd_stores_string
    start 'pwd'
    assert_eq 'pwd', @parser.statement.context.first.to_s
  end
  def test_command_properly_returns_false
    start "\n"
    assert_false @parser.statement
    assert_eq 0, @parser.pos
  end


  def test_command_with_one_argument
    start 'echo foo'
    x = @parser.statement
    assert_eq 2, x.context.length
  end

  def test_command_with_multiple_arguments_is_single_statement
    start 'echo foo bar baz arg4 arg5'
    assert_eq 1, @parser.statement_list.length
  end

  def test_statement_actually_hasmultiple_arguments_within
    start 'mkdir /var/foo /xxx/yyy/ just_in_time'
    s = @parser.statement
    assert_eq 4, s.context.length

  end


  def test_multiple_statements_where_one_has_one_argument
    start 'cd /foo/bar;pwd'
    x = @parser.statement_list;
    assert_eq 2, x.length
  end
  # working with comments
  def test_comment_line_by_itself_between_2_commands
    start "pwd\n# this is a comment\necho foo\n"
    sl = @parser.statement_list
    assert_eq 2, sl.length
  end


  def test_comment_trails_command_after_some_whitespace
    start "pwd\necho foo  \t# this is a comment\n"
    sl = @parser.statement_list
    assert_eq 2, sl.length
  end
  # compound tests of statement lists
  def test_compound_with_leading_newlines_and_comments
    start <<-EOD
    
      # a comment
      pwd
      
      
      echo foo # trailing comment
    EOD
    sl = @parser.statement_list
    assert_eq 2, sl.length
  end

  def test_assignment_semicolon_command
    start 'foo=baz; pwd'
    t = @parser.statement_list
    assert_eq Statement, t[0].class
    assert_eq Statement, t[1].class
  end

  def test_command_newline_assignment

    start "pwd  \n  abc=10  "
    t = @parser.statement_list
    assert_eq Statement, t[0].class
    assert_eq Statement, t[1].class    
  end
  
  # line number preserving
  def test_statement_preserves_line_numbers_from_token_stream
    start "pwd;echo foo\ncd foo\n"

    sl = @parser.statement_list
    assert_eq 1, sl[0].line_number
    assert_eq 1, sl[1].line_number
    assert_eq 2, sl[2].line_number
  end
  # function declarations
  def test_parameter_list_is_empty
    start ''
    assert @parser.function_args.empty?
  end
  def test_parameter_list_has_1_symbol
    start 'foo'
    t = @parser.function_args
    assert_eq 1, t.length
    assert_eq :foo, t.first
  end

  def test_parameter_list_has_3_symbols
    start 'a, b, c'
    t = @parser.function_args
    assert_eq 3, t.length
    assert_eq [:a, :b, :c], t
  end

  # function declaration
  def test_function_w_no_params
    start 'function foo() { pwd }'

    x = @parser.function_declaration
    assert_eq FunctionDeclaration, x.class
    assert x.args.empty?
    assert_eq 1, x.block.statement_list.length
  end


  def test_function_decl_has_3_arguments_all_symbols
    start 'function bar(a, b, c) { pwd }'

    x = @parser.function_declaration
    assert_eq 3, x.args.length
  end
  # lambdas
  def test_lambda_decl_has_2_args_and_a_block
    start '&(a, b) { pwd }'

    x = @parser.lambda_declaration
    assert_eq LambdaDeclaration, x.class
    assert_eq 2, x.args.length
    assert_eq 1, x.block.statement_list.length
  end

  # subshell expansion aka command substitution
  def test_subshell_expansion
    start ':( pwd )';
    x = @parser.subshell_expansion
    assert_eq 'pwd', x.block.statement_list.first.to_s
  end
  # subshell
  def test_subshell
    start '(cd minitest; ruby test_parser.rb)'
    x = @parser.subshell
    assert_eq 'ruby test_parser.rb', x.block.statement_list[1].to_s
  end


  # variable dereference
  def test_variable_dereference
    start ':baz'

    x = @parser.variable
    assert_eq Symbol, x.class
    assert_eq 'baz', x.to_s
  end

  # redirections
  def test_redirect_in
    start '< foo'
    x = @parser.p_redirection
    assert_eq Redirection, x.class
    assert_eq '<', x.op
    assert_eq 'foo', x.target.to_s
  end
  def test_redirect_out

    start '> bar'
    x = @parser.p_redirection
    assert_eq Redirection, x.class
    assert_eq '>', x.op
    assert_eq 'bar', x.target.to_s
  end
  def test_redirect_append

    start '>> baz'
    x = @parser.p_redirection
    assert_eq Redirection, x.class
    assert_eq '>>', x.op
    assert_eq 'baz', x.target.to_s
  end

  # multiple kinds of statements
  def test_can_parse_3_different_statement_types
    start 'pwd;function foo() { pwd };foo'
    
    x = @parser.statement_list
    assert_eq 3, x.length
    assert_eq Statement, x.first.class
    assert_eq FunctionDeclaration, x[1].class
    assert_eq Statement, x[2].class
  end


  def test_line_numbers_for_different_statement_types

    start "pwd\nfn foo() { pwd }\n"
    x = @parser.statement_list
    assert_eq 2, x[1].line_number
  end
  # aliases
  def test_alias_declaration
    start 'alias foo=bar'

    x = @parser.alias_declaration
    assert_eq AliasDeclaration, x.class
    assert_eq 'alias foo="bar"', x.to_s
  end

  # alias item: alias foo
  def test_alias_item
    start 'alias foo'

    x = @parser.statement_list
    assert_eq 1, x.length
    assert_eq Statement, x.first.class
  end

  # alias list: lists all aliases, this happens when evaluation occufrs
  def test_alias_list
    start "alias\nfn foo() { pwd }\necho foo"
    x = @parser.statement_list
    assert_eq 3, x.length
    assert_eq Statement, x.first.class
    assert_eq FunctionDeclaration, x[1].class
    assert_eq Statement, x[2].class
  end

  def test_alias_declaration_preserves_line_number

    start "pwd\nalias foo=bar\necho foo"
    x = @parser.statement_list
    assert_eq 2, x[1].line_number
  end

  def test_alias_item_preserves_line_number

    start "pwd\necho foo\nalias foo\n"
  x = @parser.statement_list
  assert_eq 3,x[2].line_number
  end

  def test_alias_list_preserves_line_number

  start "pwd\nfn foo() { pwd }\necho foo\nalias\n"
  x = @parser.statement_list
  assert_eq 4, x[3].line_number
    #
  end

  # subshell
  def test_subshell
    start "(cd foo; bar)"
    x = @parser.statement_list
    assert_eq 1, x.length
    assert_eq SubShell, x.first.class
    #assert_eq 1, x.first.line_number
  end

  def test_subshell_on_different_line

    start "pwd\n(cd foo; pwd)\n"
    x = @parser.statement_list
    assert_eq SubShell, x[1].class
    assert_eq 2, x[1].line_number
  end

  # subshell expansion or command substitution
  def test_subshell_expansion
    start ":(pwd)"
    x = @parser.subshell_expansion
    assert_eq SubShellExpansion, x.class
  end

  # pipes
  def test_pipe_is_2_statements
    start 'echo       foo|     cat'
    x = @parser.statement_list
    assert_eq Pipe, x.first.class
    assert_eq 'echo foo | cat', x.first.to_s
  end
  # logical and, or compound statements
  def test_logical_and
    start 'true && false'
    x = @parser.statement_list
    assert_eq BooleanAnd, x.first.class
    assert_eq 'true && false', x.first.to_s
  end

  # Logical or with ||
  def test_logical_or
    start 'false || true'

    x = @parser.statement_list
    assert_eq BooleanOr, x.first.class
    assert_eq 'false || true', x.first.to_s
  end

  # multi line function declarations
  def test_multi_line_function_decl
    start "fn baz(b) {\n  pwd\n}\n"
    assert @parser.function_declaration
  end

  # from ./local/**/*.vsh
  def test_redirect_in_w_quoted_string
    start 'foo < "bar"'
    b= @parser.p_root
    assert_eq Block, b.class
  end

  def test_redirect_out_w_single_quoted_string
    start "foo > 'bar.txt'"
    b = @parser.p_root;
    assert_eq Block, b.class
  end

  def test_redirect_append_w_double_quoted_pathname
    start 'echo foo >> "/foo/bar/"'
    b = @parser.p_root
    assert_eq Block, b.class
  end
  # for loops and maybe catch blocks need optional newline tokens after lbrace and before rbrace
  def test_for_loop_w_multi_line
    start  "for i in boo oob spam {\n echo :i \n}"
    b = @parser.p_root
    assert_eq Block, b.class
  end


  def test_multiline_loop
    full "loop {\n cond { eq :i 0 } { break } else { perr :i } \n}\n"
  end

  def test_catch_w_multiline_blocks
    full "catch {\n pwd \n} {\n echo ok \n}"
  end

  # lambda problems
  def test_lambda_decl_can_finish_with_ident_followed_with_rbrace
    full 'exec &() { echo bar}'
  end

  def test_single_quoted_string_returns_quoted_string
    start "'foo'"
    assert_eq QuotedString, @parser.string().class
  end
  def test_double_quoted_string_returns_string_literal
    start '"bar"'
    assert_eq StringLiteral, @parser.string().class
  end
  def test_dquoted_strings_are_unquoted_before_stored
    start '"foo"'
    x = @parser.string()
    assert_neq '"', x.storage[0]
    assert_neq '"', x.storage[-1]
  end
  def test_single_quoted_string_is_unquoted_before_storage
    start "'bar'"
    x = @parser.string()
    assert_neq "'", x.storage[0]
    assert_neq "'", x.storage[-1]
  end
  # collect any redirections into a list. See below for call out to subshell.
  def test_redirection_list_handles_1_redirection
    start '< foo.txt'
    x = @parser.redirection_list
    assert_eq 1, x.length
    assert_eq Redirection, x.first.class
  end
  def test_redirection_list_is_emppty
    start '(echo foo)'
    x = @parser.redirection_list
    assert_eq Array, x.class
    assert x.empty?
  end
  def test_redirection_list_is_2
    start '< foo.txt >> bar.txt'
    x = @parser.redirection_list
    assert_eq 2, x.length
  end
  # Now test all the possible subshell given 0, 1 or 2 redirections
  def test_subshell_with_1_redirection
    start '< foo.txt (cat)'
    x = @parser.subshell
    assert_eq SubShell, x.class
    assert_eq 1, x.redirections.length
  end
  def test_subshell_when_redirection_trails_parens
    start '(cat) > foo.txt'
    x = @parser.subshell
    assert_eq SubShell, x.class
    assert_eq 1, x.redirections.length
  end
end
