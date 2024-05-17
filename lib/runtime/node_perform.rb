# node_perform.rb: module NodePerform - Behaviour common to extracting  VFS nodes

module NodePerform
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

end