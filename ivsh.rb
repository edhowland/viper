#!/usr/bin/env ruby
# ivsh.rb: The Vish REPL using the reline library;
# Note: this does not replace ivsh. Yet.

require_relative 'libvish'

# main

vm = vish_boot
load_vishrc vm: vm
veval('import repl', vm: vm)

repl vm: vm
