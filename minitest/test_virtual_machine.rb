# virtual_machine_tests.rb - tests for VirtualMachine

require_relative 'test_helper'

class VirtualMachineTests < MiniTest::Test
  def setup
  @orig_dir = File.dirname(File.expand_path(__FILE__))
    @errbuf = StringIO.new
    @outbuf = StringIO.new
    @vm = VirtualMachine.new
    @vm.cd @orig_dir, env:@vm.ios, frames:@vm.fs
    @vm.cdbuf[1] = @orig_dir
    @vm.ios[:err] = @errbuf
    @vm.ios[:out] = @outbuf
        @vm.mount '/v', env:@vm.ios, frames:@vm.fs
    @vroot = @vm.fs[:vroot]
    @oldpwd = @vm.fs[:pwd]
    @vm.fs[:proj] = Hal.pwd
  end
  def test_ok
    @vm.cd '/', env:@vm.ios, frames:@vm.fs
    assert_eq '/', @vm.fs[:pwd]
  end
  def test_cd_no_args_returns_proj_dir
    @vm.cd '/', env:@vm.ios, frames:@vm.fs
    @vm.cd  env:@vm.ios, frames:@vm.fs
    assert_eq @vm.fs[:proj], @vm.fs[:pwd]
  end
  def test_cd_non_existant_dir_does_change_pwd
    @vm.cd '/xxttzz', env:@vm.ios, frames:@vm.fs
    assert_eq @oldpwd, @vm.fs[:pwd]
  end
  def test_cd_dash_returns_oldpwd
    @vm.cd '/', env:@vm.ios, frames:@vm.fs
    @vm.cd '-', env:@vm.ios, frames:@vm.fs
    assert_eq @oldpwd, @vm.fs[:pwd]
  end
  def test_chdir_ok
    @vm._chdir '/'
    assert_eq '/', @vm.fs[:pwd]
  end
  def test_chdir_non_existant_path_raises_no_such_file_or_dir
    assert_raises Errno::ENOENT do 
      @vm._chdir '/xxyyzz'
    end
  end
  def test_cd_non_existant_dir_outputs_error_msg_to_stderr
    @vm.cd '/v/zzyyxx', env:@vm.ios, frames:@vm.fs
    assert_equal "cd: No such file or directory\n",@errbuf.string  
  end
  def test_cd_ok_has_true_exit_status
    @vm.cd '/v', env:@vm.ios, frames:@vm.fs
    assert @vm.fs[:exit_status]
  end
  def test_cd_non_existant_dir_has_false_exit_status
        result = @vm.cd '/v/xxxyyyzzz', env:@vm.ios, frames:@vm.fs
        assert_false result
  end
  def test_type_responds_ok
    assert @vm.respond_to?(:type)
  end
  def test_type_raises_argument_error_if_no_args
    assert_raises ArgumentError do
      @vm.type env:@vm.ios, frames:@vm.fs
    end
  end
  def test_type_reports_unknown_w_no_match
    @vm.type 'jj', env:@vm.ios, frames:@vm.fs
    assert_eq @vm.ios[:out].string.chomp, 'unknown'
  end
  def test_type_returns_false_w_no_match
    result = @vm.type 'jj', env:@vm.ios, frames:@vm.fs
    assert_false result
  end
  def test_type_returns_true_w_found
    @vm.fs.aliases['kk'] = 'kk'
    result = @vm.type 'kk', env:@vm.ios, frames:@vm.fs
    assert result
  end
  def test_type_finds_alias
    @vm.fs.aliases['kk'] = 'kk'
    @vm.type 'kk', env:@vm.ios, frames:@vm.fs
    assert_eq @vm.ios[:out].string.chomp, 'alias'
  end
  def test_type_function_ok
    @vm.fs.functions['fn'] = Function.new([], Block.new([]))
    @vm.type 'fn', env:@vm.ios, frames:@vm.fs
    assert_eq @vm.ios[:out].string.chomp, 'function'
  end
  def test_type_w_both_names_gives_priority_to_alias
    @vm.fs.functions['fn'] = Function.new([], Block.new([]))
    @vm.fs.aliases['fn'] = 'kk'
    @vm.type 'fn', env:@vm.ios, frames:@vm.fs
    assert_eq @vm.ios[:out].string.chomp, 'alias'
  end
  def test_type_cd_returns_builtin
    @vm.type 'cd', env:@vm.ios, frames:@vm.fs
    assert_eq @vm.ios[:out].string.chomp, 'builtin'
  end
  def test_type_w_command_returns_command
    @vm.mkdir '/v/bin', env:@vm.ios, frames:@vm.fs
    @vm.install env:@vm.ios, frames:@vm.fs
    @vm.type 'basename', env:@vm.ios, frames:@vm.fs
    assert_eq @vm.ios[:out].string.chomp, '/v/bin/basename'
  end
  def test_vm_restore_pwd_if_different
    path = File.expand_path('./lib')
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
  def test_cloned_vm_does_not_change_pwd_in_parent_vm
    pwd = @vm.cdbuf[0]
    _oldpwd = @vm.cdbuf[1]
    nvm = @vm._clone
    nvm.cd 'lib', env:nvm.ios, frames:nvm.fs
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
