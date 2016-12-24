# debugging_support.rb - modules and classes to support debugging

module Debugging
  def call block
    @block_stack = @block_stack || []
    @block_stack << block
    super
  end

  attr_reader :block_stack
end

class VirtualMachine
  prepend Debugging
end
