# buffer_commands - all classes for Buffer methods

class NoArgBufferCommand < BaseBufferCommand
  def call(*args, env:, frames:)
    buf_apply(args[0], env: env, frames: frames) do |buffer|
      @meth0.call buffer
    end
  end
end

class SingleArgBufferCommand < BaseBufferCommand
  def call(*args, env:, frames:)
    buf_apply(args[0], env: env, frames: frames) do |buffer|
      @meth.call buffer, args[1]
    end
  end
end

class IntegerArgBufferCommand < BaseBufferCommand
  def call(*args, env:, frames:)
    buf_apply(args[0], env: env, frames: frames) do |buffer|
      @meth.call buffer, args[1].to_i
    end
  end
end

class RangeArgBufferCommand < BaseBufferCommand
  def call(*args, env:, frames:)
    buf_apply(args[0], env: env, frames: frames) do |buffer|
      values = [args[1].to_i, args[2].to_i].sort
      @meth.call(buffer, Range.new(*values)).join('')
    end
  end
end

class AtBeg < BaseBufferCommand
  def call(*args, env:, frames:)
    result = false
    buf_apply args[0], env: env, frames: frames do |buffer|
      result = buffer.a_buff.length.zero?
      ''
    end
    result
  end
end

class AtFin < BaseBufferCommand
  def call(*args, env:, frames:)
    result = false
    buf_apply args[0], env: env, frames: frames do |buffer|
      result = buffer.b_buff.length.zero?
      ''
    end
    result
  end
end

class BooleanBufferCommand < BaseBufferCommand
  def call(*args, env:, frames:)
    result = false
    buf_apply args[0], env: env, frames: frames do |buffer|
      result = @meth.call buffer, args[1]
      ''
    end
    result
  end
end

class Dirty < NoArgBufferCommand
  def call(*args, env:, frames:)
    result = false
    buf_apply args[0], env: env, frames: frames do |buffer|
      result = buffer.dirty?
      ''
    end
    result
  end
end

# no arg commands
class Beg < NoArgBufferCommand; end
class Fin < NoArgBufferCommand; end
class IndentLevel < NoArgBufferCommand; end
class Col < NoArgBufferCommand; end
class Indent < NoArgBufferCommand; end
class Clear < NoArgBufferCommand; end

class Position < NoArgBufferCommand; end
class LineNumber < NoArgBufferCommand; end
class DelLine <NoArgBufferCommand; end 
class Del < NoArgBufferCommand; end
class DelAt < NoArgBufferCommand; end
class Fwd < NoArgBufferCommand; end

class Back < NoArgBufferCommand; end
class Up < NoArgBufferCommand; end
class Down < NoArgBufferCommand; end
class Line < NoArgBufferCommand; end
class At < NoArgBufferCommand; end
class WordFwd < NoArgBufferCommand; end
class WordBack < NoArgBufferCommand; end
class FrontOfLine < NoArgBufferCommand; end
class BackOfLine < NoArgBufferCommand; end
class Lline < NoArgBufferCommand; end
class Rline < NoArgBufferCommand; end

# single argument commands
class SrchFwd < SingleArgBufferCommand
  def call(*args, env:, frames:)
    buf_apply args[0], env: env, frames: frames do |buffer|
      re = string_to_regex args[1]
      buffer.srch_fwd re
    end
  end
end

class SrchBack < SingleArgBufferCommand
  def call(*args, env:, frames:)
    buf_apply args[0], env: env, frames: frames do |buffer|
      re = string_to_regex args[1]
      buffer.srch_back re
    end
  end
end

# integer single args
class FwdAmt < IntegerArgBufferCommand
  def call(*args, env:, frames:)
    buf_apply args[0], env: env, frames: frames do |buffer|
      buffer.fwd(args[1].to_i)
    end
  end
end

class Goto < IntegerArgBufferCommand; end
class GotoPosition < IntegerArgBufferCommand; end
class Within < RangeArgBufferCommand; end
class Slice < RangeArgBufferCommand; end
