# sub_shell_expansion - class SubShellExpansion - :( ...block...) -returns 
# content of the last command's output

class SubShellExpansion < SubShell
  def call env:, frames:
    my_env = env._clone
    sio = StringIO.new
    my_env[:out] = sio
    vm = frames.vm._clone
    vm.ios = my_env
    begin
      vm.call @block
    rescue VirtualMachine::BreakCalled => err
      return ''
    ensure
      sio.close_write
      sio.rewind
      return sio.read.chomp
    end
  end
  def ordinal
    COMMAND
  end
end