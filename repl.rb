#!/usr/bin/env ruby
# repl.rb: The Vish REPL using the reline library;
# Note: this does not replace ivsh. Yet.

require_relative 'vish'

# main

vm = vish_boot
load_vishrc vm: vm
repl vm: vm
