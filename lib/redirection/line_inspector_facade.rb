# line_inspector_facade - class LineInspectorFacade

class LineInspectorFacade
  def initialize buffer
    @buffer = buffer
  end
  def read
    @buffer.line
  end
end

