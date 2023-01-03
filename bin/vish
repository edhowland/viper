#!/usr/bin/env ruby
# vish.rb: wrapper to get vish loaded and processing arguments


require_relative 'libvish'


# main




vm = vish_boot
load_vishrc vm: vm


# main

begin
  veval 'load vish', vm: vm
rescue VirtualMachine::ExitCalled => err
  #$stderr.puts "VM::exitCalled with ec #{err.code}"
  exit(err.code)
end


# vm afteer all the vish code has run is passed to the at_exit do block
at_exit do
  veval('run_exit_procs', vm: vm)
  code = int_or_error(vm.fs[:exit_code])
  #$stderr.puts "in vish.rb:at_exit code is #{code}, exit_code is #{vm.fs[:exit_code]}"

  exit(code)
end

