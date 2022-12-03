# vish.rb: Vish language startup 
# Usage
# vm = vish_boot
# load_vishrc vm: vm
# repl vm: vm
#
# Above only gets a single of Vish syntax and parses and executes it. You need, at this time, to retype the above, if living in Pry
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
  pda = ReplPDA.new
        text = Reline.readmultiline(prompt, use_history) do |multiline_input|
    pda.run(multiline_input)
      end
  text
end

# The Read/Eval/Print/Loop or REPL
def repl(vm:)
  src = get_line
  block = Visher.parse!(src)
  vm.call(block)
end
