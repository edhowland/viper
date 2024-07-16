# ipl.rb: initial program load Mainframe-speak for booting

require_relative '../lib/viper'
def ipl
  vm = VirtualMachine.new
  vm.mount('/v', env: vm.ios, frames: vm.fs)
  vm
  end
  