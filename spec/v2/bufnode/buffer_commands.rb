# buffer_commands - all classes for Buffer methods

class NoArgBufferCommand < BaseBufferCommand
    def call *args, env:, frames:
        buf_apply(args[0], env:env, frames:frames) do |buffer|
      @meth0.call buffer
    end
  end
end

class SingleArgBufferCommand < BaseBufferCommand
    def call *args, env:, frames:
        buf_apply(args[0], env:env, frames:frames) do |buffer|
      @meth.call buffer, args[1]
    end
  end  
end



class IntegerArgBufferCommand < BaseBufferCommand
    def call *args, env:, frames:
        buf_apply(args[0], env:env, frames:frames) do |buffer|
      @meth.call buffer, args[1].to_i
    end
  end  
end

class Beg < NoArgBufferCommand; end
class Fin < NoArgBufferCommand; end
class Col < NoArgBufferCommand; end
class Indent < NoArgBufferCommand; end
class Clear < NoArgBufferCommand; end

class Position < NoArgBufferCommand; end
class LineNumber < NoArgBufferCommand; end
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
 class SrchFwd < SingleArgBufferCommand; end
 class SrchBack < SingleArgBufferCommand; end

# integer single args
class Goto < IntegerArgBufferCommand; end
class GotoPosition < IntegerArgBufferCommand; end
