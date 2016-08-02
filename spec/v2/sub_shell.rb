# sub_shell - class SubShell - ( block ) - runs in a new VM

class SubShell
  def initialize block
    @block = block
    @pwd = ''
    @oldpwd = ''
    @vm = nil
  end
  def save_pwd vm
    @pwd = vm.fs[:pwd]
    @oldpwd = vm.fs[:oldpwd]
  end
  def restore_pwd vm
    vm.cd @pwd, env:vm.ios, frames:vm.fs
    vm.fs[:oldpwd] = @oldpwd
  end
  def call env:, frames:
    @vm = frames.vm
    save_pwd @vm
    vm = @vm._clone
    begin
      vm.call @block
    rescue VirtualMachine::BreakCalled => err
      return true
    ensure
      restore_pwd @vm
    end
  end
  def ordinal
    COMMAND
  end
def to_s
  '(' + @block.to_s + ')'
end
end

