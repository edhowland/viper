# debug.rb : methods: source(fname)

def source fname
    src = File.read($vm.fs[:vhome] + "/" + fname)
  bk = Visher.parse!(src)
  $vm.call(bk)

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

def vmcd path
  vhome = $vm.fs[:vhome]
  $vm.cd("#{vhome}/#{path}", env: $vm.ios, frames: $vm.fs)
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