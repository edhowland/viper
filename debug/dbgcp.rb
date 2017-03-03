$virt = VirtualMachine.new
$virt.mount '/v', env:$virt.ios, frames:$virt.fs
Hal.chdir '/v'
VirtualLayer.touch 'file'
VirtualLayer.mkdir_p 'dir'
$root = $virt.fs[:vroot]
$wd = $root.wd
VirtualLayer.touch 'old'

$file = $wd['file']
$file.print 'hwllo'
$file.rewind
