# base_node_command - class BaseNodeCommand - base class for command primitive
# gathers argument to node and passes to supplied block

class BaseNodeCommand < BaseCommand
  def get_node path, frames:
        root = frames[:vroot]
    root[path]
  end
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
  def perform_new path, env:, frames:, &blk
    dir = path.pathmap('%d')
    base = path.pathmap('%f')
    root = frames[:vroot]
    node = root[dir]
    output = ''
    result = true
    output = blk.call(node, base) if block_given?
    result
  end
end
