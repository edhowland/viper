# variable_derefencer - classVariableDerefencer - derefences a symbol from frame

class VariableDerefencer
  def initialize frames
    @frames = frames
  end
  def [] sym
    @frames.reduce('') { |i, j| j[sym] || i }
  end
end

