# test_ helper.rb: requires for testing
require_relative '../lib/viper'
# Put test helper classes and modules here
require_relative 'lib/ext_assertions'
require_relative 'lib/my_mock'

# helper function to get boot.vsh path

def boot_vsh
  File.expand_path("#{__dir__}/../pry/boot.vsh")
end

# This helper method will load the VirtualMachine along w/ :vhome/etc/vishrc -
# loads all the mount pts and commands, including viper commands
def boot_helper
  vm = VirtualMachine.new
  vm.call(Visher.parse!(File.read(boot_vsh())))
  vm
end


def veval code, vm: $vm
  bk = Visher.parse! code
  vm.call bk
end


def source(path, vm:)
  src = File.read(path)
  bk = Visher.parse!(src)
  vm.call(bk)  
end

# boot_etc, like :vhome/pry/boot_etc.rb
def boot_etc
  vm = boot_helper
  boot({}, vm).each {|v| source(v, vm: vm) }
  vm
end

# add nothing further than the next line
require 'minitest/autorun'

