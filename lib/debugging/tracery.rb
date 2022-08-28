# tracery.rb: class Tracery. Inject optional trace to $vm (VirtualMachine)

class Tracery
  def initialize(fd: $stderr)
    @fd = fd
  end
  attr_reader :fd
  def prelude
    "trace: "
  end
  def track(*args)
    fd.puts(prelude() +  args.join('|'))
  end
end
