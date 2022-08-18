# string_literal - class StringLiteral - Nodes for bare strings and double
# quoted
#  "" strings
# ones. Will try to interpolate embedded variable derefs

class StringLiteral < QuotedString
  def call(frames:, env: {})
    string = super
    interpolate string, frames: frames
  end

  protected

  def decurlify(arg)
    m = arg.match(/:\{([_a-zA-Z0-9]+)\}/)
    return '' if m.nil?
    m.captures.first
  end

  def interpolate(string, frames:)
    string.gsub(/:\{[_a-zA-Z0-9]+\}/).each do |v|
      var_s = decurlify(v)
      if var_s.nil?
        ''
      else
        value = frames[var_s.to_sym]
        value = value.join(' ') if value.instance_of?(Array)
        value
      end
    end
  end
end
