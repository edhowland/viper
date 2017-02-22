# debugging_support.rb - modules and classes to support debugging

def trace_range
  r = rangify(ENV['RNG'])
  return 0..-1 if r.nil?
  r
end

$call_stack = []

$verbosep = ->(x) { x.class.name + ':' + x.to_s }

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
    @fs.first[:_debug] = true
    super
  end

  attr_reader :block_stack
end

class VirtualMachine
  prepend Debugging
end



class DebugHolder
  def initialize object, env:, frames:
    @object = object
    @env = env
    @frames = frames
  end

  def to_s
    @object.class.name + ':' + @object.to_s + ':' + @frames.slice(-5..-1).inspect
  end
end

module CallRecorder
  def call env:, frames:
    $call_stack.push DebugHolder.new(self, env:env, frames:frames)
    result = super
    $call_stack.pop
    result
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
    result
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

module TraceWhenInException
  def message
    commandp = ->(e) {
      case e
      when Block
        'Block'
      when Statement
        "Statement:#{e.to_s}"
      when Function
        "Function:#{e.name}"
      when DebugHolder
        e.to_s
      else
        'unknown'
      end
    }
    howdidigethere(&commandp)[trace_range].join("\n") + "\n" + super
  end
end


  class CommandNotFound
    prepend TraceWhenInException
  end