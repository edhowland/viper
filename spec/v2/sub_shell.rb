# sub_shell - class SubShell - ( block ) - runs in a new VM

class SubShell
  def initialize block
    @block = block
  end
  def call env:, frames:
    vm = frames.vm._clone
    vm.call @block
  end
end
