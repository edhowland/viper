# debugging_support.rb - modules and classes to support debugging


$call_stack = []


def howdidigethere &blk
  if block_given?
    $call_stack.map &blk
  else
    $call_stack.map {|e| e.to_s }
  end
end

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


module CallRecorder
  def call env:, frames:
    $call_stack.push self
    result = super
    $call_stack.pop
  end
end

class Statement
  prepend CallRecorder
end


class Block
  prepend CallRecorder
 end
 
module CallWArgsRecorder
  def call *args, env:, frames:
    $call_stack.push self
    result = super
    $call_stack.pop
  end
end



class Function
  prepend CallWArgsRecorder
end

class Trace < BaseCommand
  def call *args, env:, frames:
    a = howdidigethere {|e| e.class.name + ':' + e.to_s }
    a.each {|e| env[:out].puts e }
  end
end
  #