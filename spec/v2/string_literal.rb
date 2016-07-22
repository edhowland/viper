# string_literal - class StringLiteral - Nodes for bare strings and dbl ""
# ones. Will try to interpolate embedded variable derefs

class StringLiteral < QuotedString
  def call frames:, env:{}
    string = super
    interpolate string, frames:frames
  end
  protected

    def decurlify arg
    m = arg.match /:{([_\w]+)\}/
    return "" if m.nil?
    m.captures.first
  end
  def interpolate string, frames:
    string.gsub(/:\{[_\w]+\}/).each do |v|
      var_s = decurlify(v)
      if var_s.nil?
        ''
      else
        frames[var_s.to_sym]
      end
    end
  end
end

