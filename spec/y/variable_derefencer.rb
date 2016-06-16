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
end

