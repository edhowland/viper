# sub_shell - class SubShell - ( block ) - runs in a new VM

class SubShell
  include Redirectable

  def initialize block, redirections=[]
    @block = block
    @redirections = redirections
    @pwd = ''
    @oldpwd = ''
    @vm = nil
  end

  def line_number
    result = 0
    if @block.statement_list.length >= 1
      result = @block.statement_list.first.line_number
    end
    result
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
    local_vars = frames
    local_vars.push
    local_ios = env
    local_ios.push
    @redirections.each {|e| redirect(e, env:local_ios, frames:local_vars) }
    vm.ios = local_ios
    vm.fs = local_vars
    closers = open_redirs env:local_ios
    begin
      vm.call @block
    rescue VirtualMachine::BreakCalled => err
      return true
    ensure
      restore_pwd @vm
      close_redirs closers
      local_vars.pop
      local_ios.pop
    end
  end
  def ordinal
    COMMAND
  end
def to_s
  '(' + @block.to_s + ')'
end
end
