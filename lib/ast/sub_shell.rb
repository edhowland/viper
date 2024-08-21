# sub_shell - class SubShell - ( block ) - runs in a new VM

class SubShell
  include Redirectable
  include ClassEquivalence

  def initialize(block, redirections = [])
    @block = block
    @redirections = redirections
    @pwd = ''
    @oldpwd = ''
#    @vm = nil
  end
  attr_reader :block
  def line_number
    result = 0
    if @block.statement_list.length >= 1
      result = @block.statement_list.first.line_number
    end
    result
  end

  def save_pwd(vm)
    @pwd = vm.fs[:pwd]
    @oldpwd = vm.fs[:oldpwd]
  end

  def restore_pwd(vm)
    vm.cd @pwd, env: vm.ios, frames: vm.fs
    vm.fs[:oldpwd] = @oldpwd
  end

  def call(env:, frames:)
    klone = frames.vm._clone
    klone.ios[:out] = env[:out]
    klone.ios[:in] = env[:in]
    klone.ios[:err] = env[:err]

    klone.ios.push
    @redirections.each { |e| redirect(e, env: klone.ios, frames: frames) }
    closers = open_redirs env: klone.ios

     # start to make local frames
nf = frames._clone
    #klone.fs = frames._clone
    klone.fs.frames = nf.frames
    # need to reset internal lambdas for :pid, :ppid
    #  vars after originally dumping framestack
    klone.restore_pids
    klone.restore_oldpwd
    klone.fs.push

    result = true
    begin
      result = klone.call(@block)
#    rescue VirtualMachine::BreakCalled
#      return true
    ensure
      frames.vm.restore_pwd 
      close_redirs closers
    klone.ios.pop
      frames[:exit_status] = result
      result
    end
  end



  def _call(env:, frames:)
    _vm = frames.vm
#    save_pwd _vm
    vm = _vm._clone
    local_vars = vm.fs
    local_ios = vm.ios
#    local_vars = frames
    local_vars.push
#    local_ios = env
    local_ios.push
    @redirections.each { |e| redirect(e, env: local_ios, frames: local_vars) }
#    vm.ios = local_ios
#    vm.fs = local_vars
    closers = open_redirs env: local_ios
    begin
      result = vm.call @block
    rescue VirtualMachine::BreakCalled
      return true
    ensure
      #restore_pwd @vm
      _vm.restore_pwd
      close_redirs closers
#      local_vars.pop
#      local_ios.pop
    end
frames[:exit_status] = result
    result
  end

  def ordinal
    COMMAND
  end

  def to_s
    '(' + @block.to_s + ')' + @redirections.map {|r| r.to_s }.join(' ')
  end
  def ==(other)
    class_eq(other) && other.block == self.block
  end
end
