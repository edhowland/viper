# verb_finder.rb: class VerbFinder
# A verb is any type of alias, function, builtin, command or commandlet
# They are searched in that order. IOW: Any previous found match takes priority over potential later matches
# that can appear in the first position of a statement: echo hello world
# the verb is echo
# VerbFinder is a single source of truth for the type and location of the verb

class VerbFinder
  class AliasFinder < self
    def find(name, vm:)
      res = vm.fs.aliases[name]
      unless res.nil?
        [:alias, res]
      else
        nil
      end
    
    end
  end
  class FunctionFinder < self
    def find(name, vm:)
      res = vm.fs.functions[name]
      unless res.nil?
        [:function, res]
      else
        nil
      end
    end
  end
  class BuiltinFinder < self
    def find(name, vm:)
      res = vm._builtins.member?(name.to_sym)
      if res
        [:builtin,  name]
      else
        nil
      end
    end
  end
  class CommandFinder < self
    def find(name, vm:)
      res = Command.first_in_path(name, frames: vm.fs)
      unless res.nil?
        [:command, res]
      else
        nil
      end
    end
  end
  class VariableFinder < self
    def find(name, vm:)
      res = vm.fs.key?(name.to_sym)
      if res
        [:variable, vm.fs[name.to_sym]]
      else
        nil
      end
    end
  end
  def find(name, vm:)
    [AliasFinder, FunctionFinder, BuiltinFinder, CommandFinder, VariableFinder].map {|k| k.new.find(name, vm: vm) }.find {|e| e.instance_of?(Array) }
    
  end
end