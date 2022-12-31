#!/usr/bin/env ruby
# run-pkg.rb - loads a packages and runs a command  from ./viper.rb




require_relative 'libvish'


# main




pkg = ARGV[0]
ARGV.shift
i=ARGV.index('-')

if i
  stmt = i.zero? ? 'nop' : ARGV.first
  ARGV.shift(i+1)
  #puts "ARGV was shift #{i+1}"
else
  stmt = ARGV.last || 'nop'
end
#puts "will load #{pkg} and then run '#{stmt}'. After will pass these args to package: #{ARGV}"

lpath='.'

vm = vish_boot
load_vishrc vm: vm



begin
  veval "lpath=\"#{lpath}::{lpath}\" load #{pkg}", vm: vm
  veval(stmt, vm: vm)
rescue VirtualMachine::ExitCalled => err
  vm.fs.first[:exit_code] = err.code.to_i
#exit(err.code)
end


# vm afteer all the vish code has run is passed to the at_exit do block
at_exit do
  #$stderr.puts "about to run exit procs"
  veval('run_exit_procs', vm: vm)
  code = int_or_error(vm.fs[:exit_code])
  #$stderr.puts "in vish.rb:at_exit code is #{code}, exit_code is #{vm.fs[:exit_code]}"

  exit(code)
end

