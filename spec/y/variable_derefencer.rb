# variable_derefencer - classVariableDerefencer - derefences a symbol from frame

class VariableDerefencer
  def initialize frames
    @frames = frames
  end
  def [] sym
    result = @frames.reduce('') do |i, j|
      j[sym] || i 
    end
    result.to_s
  end
  def decurlify arg
    m = arg.match /:{([_\w]+)\}/
    return "" if m.nil?
    m.captures.first
  end
  def interpolate_str string
    string.gsub(/:\{[_\w]+\}/).each do |v|
      var_s = decurlify(v)
      if var_s.nil?
        ''
      else
        self[var_s.to_sym]
      end
    end
  end
  
end

