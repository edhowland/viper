#!/usr/bin/env ruby
# ivsh.rb: The Vish REPL using the reline library;
# Note: this does not replace ivsh. Yet.

require_relative 'libvish'

# main

vm = vish_boot
begin 
  load_vishrc vm: vm
  veval 'load repl', vm: vm
rescue VirtualMachine::ExitCalled => err
  exit(err.code.to_i)
end

begin
  repl vm: vm
rescue VirtualMachine::ExitCalled => err
  #exit(err.code)
  vm.fs.first[:exit_code] = err.code.to_i
end


# vm afteer all the vish code has run is passed to the at_exit do block
at_exit do
  veval('run_exit_procs', vm: vm)
  code = int_or_error(vm.fs[:exit_code])
  #$stderr.puts "in vish.rb:at_exit code is #{code}, exit_code is #{vm.fs[:exit_code]}"

  exit(code)
end

