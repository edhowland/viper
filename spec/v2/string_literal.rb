# string_literal - class StringLiteral - Nodes for bare strings and dbl ""
# ones. Will try to interpolate embedded variable derefs

class StringLiteral < QuotedString
  def call frames:
    string = super
    # interpolate ...
    string
  end
end

