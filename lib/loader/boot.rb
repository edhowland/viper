# boot.rb - class 

def boot(opt, vm)
  opt[:no_start] ? [] : [vm.fs[:vhome] + '/etc/vishrc']
end
