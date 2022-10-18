# boot.rb : Setup the VirtualMachine environment for Vish programs

def boot
  $vm = VirtualMachine.new
  src = File.read(__dir__ + '/boot.vsh')
  block = Visher.parse!(src)
  $vm.call(block)
end