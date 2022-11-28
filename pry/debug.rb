# debug.rb : methods: source(fname)


def source(path)
  src = File.read(path)
  bk = Visher.parse!(src)
  $vm.call(bk)  
end

# handy means for source local files in pry debugger
def vhome_source fname
    source($vm.fs[:vhome] + "/" + fname)


end

def veval code
  bk = Visher.parse! code
  $vm.call bk
end


class DHold
  def initialize param
    @param =  param
  end
  attr_reader :param
  def call frames:
    @param
  end
end

# Use the above to make a new Glob object, that be called: call env: vm.ios, frames: vm.fs
def mkglob pat
  Glob.new(DHold.new(pat))
end


def cdvm path
  $vm.cd(path, env: $vm.ios, frames: $vm.fs)
end

def vmcd path, vm: $vm
  vhome = vm.fs[:vhome]
  vm.cd("#{vhome}/#{path}", env: vm.ios, frames: vm.fs)
end

def cwd
  Hal.pwd
end


module VMDebuggable
  def vmdebug?
    @vmdebug
  end
  def vmdebug_on
    @vmdebug = true
  end
  def vmdebug_off
    @vmdebug = false
  end
end

## minitest debug support

def what_dir
  puts __dir__
end

# use this to get the current vhome or the location of the invocation source dir
def vhome(vm=$vm)
  vm.fs[:vhome]
end

# use this to get the current vm's pwd
def vmpwd(vm: $vm)
  vm.fs[:pwd]
end

# vhome_script: loads a single script
def vhome_script script , vm: $vm
  src = vm.fs[:vhome] + '/' + script
  source src
end