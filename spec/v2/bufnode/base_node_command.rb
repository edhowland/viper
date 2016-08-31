# base_node_command - class BaseNodeCommand - base class for command primitive
# gathers argument to node and passes to supplied block

class BaseNodeCommand < BaseCommand
  def perform path, env:, frames:,  &blk
    root = frames[:vroot]
    node = root[path]
    result = true
    output = ''
    output = yield node if block_given?
    if output.nil?
      result = false
      output = ''
    end
    env[:out].print output
    result
  end
end
