#!/usr/bin/env ruby
# vish.rb: wrapper to get vish loaded and processing arguments


require_relative 'libvish'


# main




vm = vish_boot
load_vishrc vm: vm


# main

veval('import init', vm: vm)


# vm afteer all the vish code has run is passed to the at_exit do block
at_exit do
  veval('run_exit_procs', vm: vm)
end

