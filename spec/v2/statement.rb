# statement - classStatement - statement node in AST

require_relative 'context_constants'

class Statement
  def initialize context=[]
    @context = context
  end
  attr_reader :context

  # sort the @context array by ordinal numbertake any command args and move them
  # the assignments and command. The command is the first arg or glob or deref.
  # the args are the rest of the array.
  def call env:, frames:
    local_vars = frames
    local_vars.push
    local_ios = env
    local_ios.push
    sorted = @context.sort {|a, b| a.ordinal <=> b.ordinal }
    sorted.map! {|e| e.call env:local_ios, frames:local_vars }
    sorted.reject!(&:nil?)
    c, *args = sorted
    command = Command.resolve(c, frames:frames)
    closers = local_ios.values
    local_ios.top.each_pair {|k, v| local_ios[k] = v.open }

    result = command.call *args,  env:local_ios, frames:local_vars

    closers.each {|f| f.close }
    local_ios.pop
    local_vars.pop
    local_vars[:exit_status] = result
    result
  end
  def to_s
    @context.map {|e| e.to_s }.join(' ')
  end
end

