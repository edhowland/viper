# statement - classStatement - statement node in AST

require_relative 'context_constants'

class Statement
  include Redirectable

  def initialize context=[], line_number=0
    @context = context
    @line_number = line_number
  end
  attr_reader :context, :line_number
  def call_expanded env:, frames:
    string = @context.map {|e| e.to_s }.join(' ')
    block = Visher.parse! string
    block.call env:env, frames:frames
    frames.vm.seen.pop
  end

  # sort the @context array by ordinal numbertake any command args and move them
  # the assignments and command. The command is the first arg or glob or deref.
  # the args are the rest of the array.
  def call env:, frames:
    # check if we have an alias expansion
    possible_alias = @context.find {|e| e.ordinal == COMMAND }
    real_alias = possible_alias.to_s
    expansion = frames.aliases[real_alias]
    unless expansion.nil?
      if frames.vm.seen.member? real_alias
        env[:err].puts "#{real_alias} not found"
        return false
      else
        frames.vm.seen << real_alias
      end
      @context[@context.index(possible_alias)] = StringLiteral.new(expansion)
      call_expanded env:env, frames:frames
    else
    local_vars = frames
    local_vars.push
    local_ios = env
    local_ios.push

    sorted = @context.sort {|a, b| a.ordinal <=> b.ordinal }
    sorted = sorted.reject {|e| redirectable?(e) && redirect(e, env:local_ios, frames:local_vars) }.map {|e| e.call env:local_ios, frames:local_vars }
    sorted.flatten!
    sorted.reject!(&:nil?)
    c, *args = sorted
    command = Command.resolve(c, env:env, frames:frames)
#binding.pry
    # closers = local_ios.values
    # local_ios.top.each_pair {|k, v| local_ios[k] = v.open }
    closers = open_redirs env:local_ios
    begin
      result = command.call *args,  env:local_ios, frames:local_vars
    ensure
      #closers.each {|f| f.close }
      close_redirs closers
      local_ios.pop
      local_vars.pop
      frames[:exit_status] = result
    end
    result
  end
  end
  def to_s
    @context.map {|e| e.to_s }.join(' ')
  end
end
