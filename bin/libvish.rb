# vish.rb: Vish language startup 
# Usage
# vm = vish_boot
# load_vishrc vm: vm
# repl vm: vm
#
# Above only gets a single of Vish syntax and parses and executes it. You need, at this time, to retype the above, if living in Pry
require 'reline'

require_relative '../lib/viper'


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


def safe_get_line(prompt="vish3")
  res=get_line(prompt=prompt)
  if res.nil?
    return 'ctrl_d'
  end
  return res
  rescue Interrupt
  $stderr.puts "Control C"
end

def get_line(prompt='vish2>')
  #prompt = 'vish>> '
  use_history = true
  pda = ReplPDA.new
        text = Reline.readmultiline(prompt, use_history) do |multiline_input|
    pda.run(multiline_input)
      end
  text
end

# The Read/Eval/Print/Loop or REPL
def repl(vm:)
  Reline.prompt_proc = ->(x) {   [vm.fs[:prompt], vm.fs[:prompt2]] }
  loop do
  $stdout.print("\n")
    src = get_line(prompt=vm.fs[:prompt])
    return nil if src.nil?
    unless src.empty?
      block = Visher.parse!(src)
      vm.call(block)
    end
  rescue Interrupt
    $stderr.puts "Ctrl-C"
  rescue ArgumentError => aerr
    $stderr.puts aerr.message
  rescue VishSyntaxError => synerr
    $stderr.puts synerr.message
  rescue VishRuntimeError => verr
    $stderr.puts verr.message
  rescue VirtualMachine::ReturnCalled
    $stderr.puts "Cannot call return from outside a function"
  end
  $stderr.puts "Ctrl-C"
  #exit(0)
rescue VirtualMachine::ExitCalled => err
  exit(err.code.to_i)
rescue RuntimeError => err
  $stderr.puts err.message
rescue => err
  $stderr.puts err.message
end


# eval a Vish source string
def veval(src, vm:)
    bk = Visher.parse! src
  vm.call bk
end
