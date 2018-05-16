# vish_parser.rb -  class VishParser <  < Parslet::Parser
# TODO: Remove this file
# generates a parser from our grammar
# This grammar accepts strings: integer | integer + integer | function(expr [, expr)
# Usage: parser = VishParser.new; parser.parse('puts(1+2,3)') => Hash of intermediate AST
# email address for parslet authors:
# ruby.parslet@librelist.com

  require 'parslet' 

class VishParser < Parslet::Parser

  # empty string
  rule(:empty) { str('').as(:empty) }

  rule(:newline) { str("\n") }
  # This is Whitespace, not a single space; does not include newlines. See that rule
  rule(:space) { match(/[\t ]/).repeat(1) }
  rule(:space?) { space.maybe }
  rule(:space!) { space >> space? }
  # whitespace including newlines
  rule(:ws) { (newline | space).repeat(1) }
  rule(:ws?) { ws.maybe }

  # single character rules
  rule(:semicolon) { str(';') }
  # The octothorpe - '#'
  rule(:octo) { str('#') }
  rule(:lparen)     { str('(') >> space? }
  rule(:rparen)     { str(')') >> space? }
  rule(:lbrace) { str('{') >> space? }
  rule(:rbrace) { str('}') >> space? }
  rule(:lbracket) { str('[') >> space? }
  rule(:rbracket) { str(']') >> space? }
  # The quotation delimiters - :< print("some Vish string") >:
  rule(:qleft) { str(':<') >> space? }
  rule(:qright) { str('>:') >> space? }
  rule(:langle) { str('<') >> space? }
  rule(:rangle) { str('>') >> space? }

    rule(:comma)      { str(',') >> space? }
  rule(:equals) { str('=') >> space? }
  rule(:colon) { str(':') }
  rule(:plus) { str('+') >> ws? }  #space? }
  rule(:minus) { str('-') >> ws? }
  rule(:star) { str('*') >> ws? }
  rule(:fslash) { str('/') >> ws? }
  rule(:bslash) { str('\\') }
  rule(:percent) { str('%') >> space? }
  rule(:star_star) { str("\*\*") >> ws? }
  # some punctuation
  rule(:dquote) { str('"') }
  rule(:squote) { str("'") }
  rule(:period) { str('.') }
  rule(:tilde) { str('~') }
  # Logical ops
  rule(:bang) { str('!') }
  rule(:l_and) { str('and') >> space? }
  rule(:l_or) { str('or') >> space? }
    rule(:equal_equal) { str('==') >> space? }
  rule(:bang_equal) { str('!=') >> space? }
  rule(:lte) { langle >> equals >> space? }
  rule(:gte) { rangle >> equals >> space? }
  # data types
  rule(:symbol) { identifier.as(:symbol) >> colon >> space? }
  rule(:list) { lbracket.as(:list) >>  arglist.as(:arglist) >> rbracket }
  rule(:list_index) { deref >> list }
  rule(:execute_index) { deref_block >> list >> (lparen >> arglist.as(:lambda_args) >> rparen).maybe >> space? }

  # Pair data type: Key/value store
  rule(:pair) { symbol >> space? >> expr.as(:expr) }
  rule(:object) { tilde >> lbrace.as(:object) >> arglist.as(:arglist) >> rbrace }

  # keywords
  # Compile time keywords
  rule(:pragma) { str('pragma') >> space! >> sq_string.as(:pragma) }
  rule(:import) { str('import') >> space! >> parmlist.as(:import_list) }
  rule(:export) { str('export') >> space! >> parmlist.as(:export_list) }

  # Runtime keywords
  rule(:_break) { str('break').as(:break) >> space? }
  rule(:_exit) { str('exit').as(:exit) >> space? }
  rule(:_return) { (str('return') >> space! >> expr).as(:return) }
  # This forces a explicit :icall opcode in the bytecode stream
  rule(:_icall) { (str('_icall') >> space! >> symbol).as(:_icall) }

  # keywords for builtin data types
#  rule(:null) { str('null').as(:null) >> space? }

  rule(:keyword) { (_break | _exit | _return | pragma | import | export | _icall) }

  # Control flow
  rule(:loop) { str('loop') >> space! >> block.as(:loop) }
  rule(:ampersand) { str('&') }
  rule(:pipe) { str('|') }
  rule(:logical_and) { ampersand >> ampersand >> space? }
  rule(:logical_or) { pipe >> pipe >> space? }

  rule(:integer) { match('[0-9]').repeat(1).as(:int) >> space? }
  rule(:bool_t) { str('true') >> space? }
  rule(:bool_f) { str('false') >> space? }
  rule(:boolean) { (bool_t | bool_f).as(:boolean) }


  # string interpolation stuff
  # See: Notes.md
  rule(:percent_lbrace) { percent >> lbrace }
  rule(:deref_expr) { percent_lbrace >> expr >> rbrace }

  # escape sequences
  rule(:esc_newline) { bslash >> str('n') }
  rule(:esc_tab) { bslash >> str('t') }
  rule(:esc_bel) { bslash >> str('a') }

  rule(:esc_bslash) { bslash >> bslash }
  rule(:esc_dquote) { bslash >> dquote }
  rule(:esc_squote) { bslash >> squote }
  rule(:esc_dquote) { bslash >> dquote }
  # TODO: make room for hex digits: \x00fe, ... posibly unicodes, etc
  rule(:escape_seq) { esc_newline | esc_tab | esc_bslash | esc_dquote | esc_squote | esc_dquote | esc_bel }


  # interpolated string is any amount of string_atoms, deref_expr and escape_seq 
  # surrounded by dquotes
  #
    # a string atom is a string_quark and  or a deref_expr(:{ expr }) , or a an escape_seq(\n, ...)
    rule(:string_quark) { dquote.absent? >> any }
    rule(:string_atom) { escape_seq.as(:escape_seq) | deref_expr.as(:string_expr) | string_quark.as(:strtok) }

  # A stringcule  (string molecule)  is  any sequence of string atoms
    rule(:stringcule) { string_atom.repeat }
    rule(:string_interpolation) { dquote >> stringcule.as(:string_interpolation) >> dquote }

  # from parslet/examples/string_parser.rb. But changed to single quotes "'this is a string'"
    rule(:sq_string) do
    str("'") >> 
    (
      (str('\\') >> any) |
      (str("'").absent? >> any)
    ).repeat.as(:sq_string) >> 
    str("'") >> space?
  end
  rule(:dq_string) { string_interpolation >> space? }

  # An identifier is an ident_head (_a-zA-Z) followed by 0 or more of ident_tail, which ident_head + digits
  rule(:ident_head) { match(/[_a-zA-Z]/) }
  rule(:ident_tail) { match(/[a-zA-Z0-9_\?!]/).repeat(1) }
  rule(:identifier) { ident_head >> ident_tail.maybe }



  # matches anything upto a newline
  rule(:notnl) { match(/[^\n]/).repeat }
  rule(:comment) { octo >> notnl >> newline.maybe }

  # operators and precedence
  # Note: Only do binary operators here. The meaning of infix!
  rule(:infix_oper) { infix_expression(group,
    [star_star, 5, :right],
    [star, 4, :left], [fslash, 4, :left], [percent, 4, :left],
    [plus, 3, :right], [minus, 3, :right],
     [lte, 2, :left], [gte, 2, :left], [equal_equal, 2, :left], [bang_equal, 2, :left], [langle, 2, :left], [rangle, 2, :left],
    [l_and, 1, :left], [l_or, 1, :left]) }

  # parenthesis:
  rule(:group) { lparen >> space? >> infix_oper >> space? >> rparen | lvalue }

  rule(:lvalue) { integer | boolean | dq_string | sq_string | list_index | execute_index | method_call | object_deref | deref | lambda_call | deref_block | block_exec | funcall | pair | symbol | list | object }

  # unary expressions
  rule(:negative) { minus.as(:op) >> space? >> expr.as(:negative) }
  rule(:negation) { bang.as(:op) >> space? >> expr.as(:negation) }

  # Assignment
  rule(:vector_identifier) { identifier.as(:vector_id) >> lbracket.as(:list) >> expr.as(:index) >> rbracket }
  rule(:vector_assign) { vector_identifier.as(:vector) >> equals.as(:eq) >> expr.as(:rvalue) }
  rule(:assign) { identifier.as(:lvalue) >> equals.as(:eq) >> expr.as(:rvalue) }
  rule(:deref) { colon >> identifier.as(:deref) >> space? }
  # This syntax: %block will cause emitter to push CodeContainer, then :exec
  rule(:deref_block) { percent >> identifier.as(:lambda_call) >> space? }
  # :{true && false} - gets promoted to lambda of no args
  rule(:block_lambda) {colon >> block.as(:block_lambda) }

  # lambda declaration: ->(x, y) { :x + :y }
  rule(:parm_atoms) { identifier.as(:parm) >> ( comma >> identifier.as(:parm)).repeat }
  rule(:parmlist) { parm_atoms | space? }
  rule(:_lambda) { str('->') >> lparen >> parmlist.as(:parmlist) >> rparen >> space? >> block.as(:_lambda) }

  # User defined functions: with 'defn' keyword
  rule(:function) { str('defn') >> space? >> identifier.as(:fname) >> lparen >> parmlist.as(:parmlist) >> rparen >> space? >> block.as(:block) }
  # Function calls 
  rule(:arg_atoms) { expr >> (comma >> expr).repeat }
  rule(:arglist) { arg_atoms |  space?   }
  rule(:funcall) { identifier.as(:funcall) >> lparen >> arglist.as(:arglist) >> rparen }

  rule(:method_call) { deref_block >> period.as(:execute_index) >> identifier.as(:index) >> (lparen >> arglist.as(:arglist) >> rparen).maybe >> space? }
  rule(:object_deref) { deref >> period.as(:list) >> identifier.as(:symbol) >> space? }

  # immediately execute a block E.g.: bk=%{ 5 + 6 }; :bk ... => 11
  rule(:block_exec) { str('%') >> block.as(:block_exec) }
  rule(:lambda_call) { str('%') >> identifier.as(:lambda_call) >> lparen >> arglist.as(:arglist) >> rparen }


  # Expressions, assignments, etc.
  rule(:expr) { quote | block | block_exec | block_lambda | _lambda | negative | negation | infix_oper | funcall | lambda_call | object | deref | deref_block  | integer | list_index }

  # A statement is either an assignment, an expression, deref(... _block) or the empty match, possibly preceeded by whitespace
  rule(:statement) { space? >> (keyword | loop | function | block | vector_assign | assign | expr | empty) }


  # pipe expressions: E.g. 99 | cat() | echo() # => "99\n"
  rule(:infix_pipe) { infix_expression(statement,
    [logical_and, 2, :left], [logical_or, 2, :left],
   [pipe, 1, :left]) }

  rule(:delim) { newline | semicolon | comment }
  rule(:statement_list) { infix_pipe >> (delim >> infix_pipe).repeat }
  rule(:block) { lbrace >> space? >> statement_list.as(:block) >> space? >> rbrace }

  # Quotation: Should resolve to AST at runtime - :< 1+2 >: 
  # =>  (:add, ((:integer, ("1"@0, ())), ((:integer, ("2"@2, ())), ())))
  rule(:quote) { str('quote') >> space? >> lbrace >> space? >> statement_list.as(:quote) >> rbrace }

  # The top node :program is made up of many statements
  rule(:program) { statement_list.as(:program) }

  # The mainroot of our tree
  root(:program)
end

