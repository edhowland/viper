# vcl_parser.rb - Parslet source for Viper Command Language VCL
#  patterned on VishParser. Compiles to exact S-Expressions as
# VishParser/SexpTransform

  require 'parslet' 

class VCLParser < Parslet::Parser
    # The mainroot of our tree
  root(:program)
  rule(:program) { statement_list.as(:program) }
  rule(:statement_list) { infix_pipe >> (delim >> infix_pipe).repeat }
  # A pipeline is either statements delimited by ';', &&', '||' or '|'
  rule(:infix_pipe) { infix_expression(statement,
    [logical_and, 2, :left], [logical_or, 2, :left],
   [pipe, 1, :left]) }

  # A statement is an identifier with possible arguments separated with one or more spaces
  rule(:complex_statement) { space? >> identifier.as(:command) >> space! >> arglist.as(:arglist) }
  rule(:arg_atoms) { arg >> (space! >> arg).repeat }
  rule(:arg) { bare_string.as(:arg) }
  rule(:arglist) { arg_atoms |  space?   }

  rule(:simple_statement) { identifier.as(:command) >> space? }
  rule(:statement) { space? >> (complex_statement | simple_statement | empty) }
  # an identifier is any string not beginning with a digit
  rule(:ident_head) { match(/[_a-zA-Z]/) }
  rule(:ident_tail) { match(/[a-zA-Z0-9_\?!]/).repeat(1) }
  rule(:identifier) { ident_head >> ident_tail.maybe }

# spaces stuff
  rule(:space!) { space >> space? }
  rule(:space?) { space.maybe }
  rule(:space) { match(/[\t ]/).repeat(1) }

  # bare_string is a string atom w/o any surrounding quotes
  rule(:bare_string) { match(/[0-9a-zA-Z]/).repeat }
  rule(:logical_and) { ampersand >> ampersand >> space? }
  rule(:logical_or) { pipe >> pipe >> space? }
  rule(:pipe) { str('|') }
  rule(:ampersand) { str('&') }

  rule(:delim) { newline | semicolon | comment }
  rule(:newline) { str("\n") }
  rule(:semicolon) { str(';') }
  rule(:comment) { octo >> notnl >> newline.maybe }
  rule(:notnl) { match(/[^\n]/).repeat }
  rule(:octo) { str('#') }

  # empty string
  rule(:empty) { str('').as(:empty) }



end
