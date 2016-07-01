# sub_shell - class SubShell - ( block ) - runs in a new VM

class SubShell
  def initialize block
    @block = block
  end
  def call env:, frames:
    vm = frames.vm._clone
    begin
      vm.call @block
    rescue VirtualMachine::BreakCalled => err
      return true
    end
  end
end
