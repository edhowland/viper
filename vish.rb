#!/usr/bin/env ruby
# vish.rb: wrapper to get vish loaded and processing arguments


require_relative 'libvish'


# main




vm = vish_boot
load_vishrc vm: vm

veval('import init', vm: vm)