# scripts.rb - method scripts - returns array of sorted pathnames in scripts/*.vsh

def scripts(_opt, vm)
  Dir[vm.fs[:vhome] + '/scripts/*.vsh'].sort
end
