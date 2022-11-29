# base_node_command - class BaseNodeCommand - base class for command primitive
# gathers argument to node and passes to supplied block

class BaseNodeCommand < BinCommand::VFSCommand
  def get_node(path, frames:)
    root = frames[:vroot]
    root[path]
  end

  include NodePerform
=begin
  def perform(path, env:, frames:)
    root = frames[:vroot]
    node = root[path]
    return false if node.nil? 
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
=end
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
