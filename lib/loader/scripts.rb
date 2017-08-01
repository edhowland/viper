# scripts.rb - method scripts

def scripts(_opt, vm)
  Dir[vm.fs[:vhome] + '/scripts/*.vsh'].sort
end


