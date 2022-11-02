# debug.rb : methods: source(fname)

def source fname
    src = File.read($vm.fs[:vhome] + "/" + fname)
  bk = Visher.parse!(src)
  $vm.call(bk)

end