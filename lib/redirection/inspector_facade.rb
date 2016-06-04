# inspector_facade - classInspectorFacade
class InspectorFacade
  def initialize buffer
    @buffer = buffer
  end
  def read
    @buffer.at
  end
end
