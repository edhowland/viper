# boot_etc.rb : Setup the VirtualMachine environment for Vish programs and adds :vhome/etc/vishrc

def boot_etc
  $vm = VirtualMachine.new
  src = File.read($vm.fs[:vhome] + '/pry/boot.vsh')
  block = Visher.parse!(src)
  $vm.call(block)
  src2 = File.read($vm.fs[:vhome] + '/etc/vishrc')
  b2 =  Visher.parse! src2
  $vm.call b2
end