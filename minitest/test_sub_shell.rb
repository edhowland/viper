# test_sub_shell.rb: tests for sub shells

require_relative 'test_helper'

class VirtualMachineTests < MiniTest::Test
  def setup
  @orig_dir = File.dirname(File.expand_path(__FILE__))
    @errbuf = StringIO.new
    @outbuf = StringIO.new
    @vm = VirtualMachine.new
    # mount must come before any cd's because it sets VirtualLayer @@root
        @vm.mount '/v', env:@vm.ios, frames:@vm.fs

    @vm.cd @orig_dir, env:@vm.ios, frames:@vm.fs
    @vm.cdbuf[1] = @orig_dir
    @vm.ios[:err] = @errbuf
    @vm.ios[:out] = @outbuf
    @vroot = @vm.fs[:vroot]
    @oldpwd = @vm.fs[:pwd]
    @vm.fs[:proj] = Hal.pwd
    @vhome = @vm.fs[:vhome]
  end
  def teardown
    assert_eq @errbuf.string, ''
  end

  def test_vm_restore_pwd_if_different
    path = File.expand_path(@vm.fs[:vhome] + "/lib")
    @vm.cd path,    env:@vm.ios, frames:@vm.fs
    Hal.chdir(ENV['HOME'], Hal.pwd)
    @vm.restore_pwd
    assert_eq Hal.pwd, path
  end
  def test_restore_pwd_does_nothing_if_already_at_pwd
    path = Hal.pwd
    @vm.restore_pwd
    assert_eq path, Hal.pwd
  end

  # commented out following test because is does in  rake test_vsh:test_sub_shell.vsh
  def _test_cloned_vm_does_not_change_pwd_in_parent_vm
    pwd = @vm.cdbuf[0]
    _oldpwd = @vm.cdbuf[1]
    nvm = @vm._clone
    nvm.cd "#{@vhome}/lib", env:nvm.ios, frames:nvm.fs
    @vm.restore_pwd
    assert_eq pwd, @vm.cdbuf[0]
  end
  def test_cloned_vm_has_not_changed_parents_oldpwd

            _pwd = @vm.cdbuf[0]
    oldpwd = @vm.cdbuf[1]
    nvm = @vm._clone
    nvm.cd 'lib', env:nvm.ios, frames:nvm.fs
    @vm.restore_pwd
    assert_eq oldpwd, @vm.cdbuf[1]
  end
  def test_pid_starts_at_two_because_of_global_vm
    assert_is @vm.pid,Integer 
  end
  def test_pid_increments_after_clone_once
    old = @vm.pid
    vv = @vm._clone
    assert_eq vv.pid, (old + 1)
  end
  def test_pid_advances_twice_after_2_clones
    old = @vm.pid
    baby = @vm._clone
    grandbaby = baby._clone
    assert_eq grandbaby.pid, (old + 2)
  end
  def test_pid_remains_unchanged_after_3_clones
    old = @vm.pid
    3.times { @vm._clone }
    assert_eq @vm.pid, old
  end
  def test_parent_pid_ppid_is_one_less_than_pid
    assert_eq @vm.ppid, (@vm.pid - 1)
  end
  def test_ppid_advances_to_parent_of_child_vm
    vv = @vm._clone
    assert_eq vv.ppid, @vm.pid
  end
  def test_ppid_is_from_actual_parent
    5.times { @vm._clone }
    baby = @vm._clone
    assert_eq baby.ppid, @vm.pid
  end
  def test_fs_pid_is_reset_to_actual_pid
    baby = @vm._clone;
    assert_eq baby.fs[:pid], baby.pid
  end
  def test_fs_ppid_retains_actual_ppid
    baby=@vm._clone
    assert_eq baby.fs[:ppid], baby.ppid
  end
  def test_restore_oldpwd_sets_current_framestack
    fs = @vm.fs._clone
    k = @vm._clone
    fs[:oldpwd] = 'xxx'
    k.fs = fs
    k.restore_oldpwd
    assert_eq k.fs[:oldpwd], k.cdbuf[1]
  end
end
