# boot.rb - method boot - returns path of etc/vishrc in array

def boot(opt, vm)
  opt[:no_start] ? [] : [vm.fs[:vhome] + '/etc/vishrc']
end
