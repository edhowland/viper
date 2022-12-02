# vish.rb: Vish language startup 
require 'reline'

require_relative 'lib/viper'


def source(path, vm:)
  src = File.read(path)
  bk = Visher.parse!(src)
  vm.call(bk)  
end



# vish_boot: perform initial Vish startup
def vish_boot
  vm = VirtualMachine.new
  source(vm.fs[:vhome] + '/local/vish/bin/boot.vsh', vm: vm)
  vm
end

# load_vishrc: Loads and runs :vhome/local/etc/vishrc
def load_vishrc vm:
  source(vm.fs[:vhome] + '/local/etc/vishrc', vm: vm)
end


def get_line
  prompt = 'vish>> '
  use_history = true

        text = Reline.readmultiline(prompt, use_history) do |multiline_input|
    true
      end
  text
end

# The Read/Eval/Print/Loop or REPL
def repl(vm:)
  src = get_line
  block = Visher.parse!(src)
  vm.call(block)
end
