# test_string_literal.rb: tests ast/StringLiteral class methods

require_relative 'test_helper'


class StringLiteralTest  < MiniTest::Test
  def test_regex_works_for_interpolation
    re = /:\{([_a-zA-Z0-9]+)\}/
    s = "foo :{bar} baz"
    m = re.match(s)
    assert_equal m.length, 2
    assert_equal m[1], 'bar'
  end
end