# base_node_command - class BaseNodeCommand - base class for command primitive
# gathers argument to node and passes to supplied block


class BaseNodeCommand
  def perform path, env:, frames:,  &blk
    root = frames[:vroot]
    node = root[path]
    result = ''
    result = yield node if block_given?
    env[:out].print result
    true
  end
end
