# base_node_command - class BaseNodeCommand - base class for command primitive
# gathers argument to node and passes to supplied block

class BaseNodeCommand < BinCommand::VFSCommand
  def get_node(path, frames:)
    root = frames[:vroot]
    root[path]
  end

  include NodePerform

  def perform_new(path, env:, frames:)
    dir = path.pathmap('%d')
    base = path.pathmap('%f')
    root = frames[:vroot]
    node = root[dir]
    result = true
    yield(node, base) if block_given?
    result
  end
end
