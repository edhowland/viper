# traceable.rb: module Traceable - Extend any callable object

module Traceable
  def init_trace
    @tracing_on = true
    @tracer = Tracery.new # TODO: make this allow for any file descriptor
  end
  def _hook(obj, &blk)
    if @tracing_on
      @tracer.track('>> ', obj.to_s)
    result = yield
    @tracer.track('<< ', obj.to_s)
    result
    else
      yield
    end
  end
  def stop_trace
    @tracing_on = false
  end
  def tracing?
    @tracing_on
  end
end

