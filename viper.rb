#!/usr/bin/env ruby
# viper.rb : derived from vish.rb but also loads viper package


require_relative 'libvish'


# main




vm = vish_boot
load_vishrc vm: vm



begin
  veval 'load vip', vm: vm
  #veval('load_viper_paths; import start; load viper;import run ', vm: vm)
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

