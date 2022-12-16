# verb_finder.rb: class VerbFinder
# A verb is any type of alias, function, builtin, command or commandlet
# They are searched in that order. IOW: Any previous found match takes priority over potential later matches
# that can appear in the first position of a statement: echo hello world
# the verb is echo
# VerbFinder is a single source of truth for the type and location of the verb

class VerbFinder

  def ordered_procs(name, vm:)
    [ 
    ->(p) { vm.fs.aliases.has_key?(name) ? p.resolve!([:alias, vm.fs.aliases[name].to_s]) : p.reject!(false) },
    ->(p) { vm.fs.functions.has_key?(name) ? p.resolve!([:function, vm.fs.functions[name]]) : p.reject!(false) },
    ->(p) { vm._builtins.member?(name.to_sym) ? p.resolve!([:builtin, name]) : p.reject!(false) },
    ->(p) { res = Command.first_in_path(name, frames: vm.fs); res ? p.resolve!([:command, res]) : p.reject!(false) },
    ->(p) { res = vm.fs[name.to_sym]; !vm.fs.key?(name.to_sym) ? p.reject!(false) : p.resolve!([:variable, res]) },
    ]
  end
  def ordered_promises(name, vm:)
    #ordered_finders.map {|f| Promise.new {|p| res = f.new.find(name, vm: vm); res.nil? ? p.reject!(res) : p.resolve!(res) } }
    ordered_procs(name, vm: vm).map {|prc| Promise.new(&prc) }
  end
  def find(name, vm:)
    of = ordered_promises(name, vm: vm)
    prom = Promise.any(of)

    if prom.run.resolved?
      prom.value.first.value
    else
      nil
    end
  end
  def find_all(name, vm:)
  prom = Promise.any(ordered_promises(name, vm: vm))
  prom.run
    return nil if prom.rejected?
    prom.value.map(&:value)

  end
end