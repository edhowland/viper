# virtual_machine_tests.rb - tests for VirtualMachine

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
  end
  def teardown
    assert_eq '', @errbuf.string
  end
  def test_ok
    vfsroot = VirtualLayer.get_root
    assert_eq vfsroot, @vroot
    @vm.cd '/', env:@vm.ios, frames:@vm.fs
    assert_eq '/', @vm.fs[:pwd]
  end
  def test_vm_has_pointer_to_self_in___vm_global_var
    assert_eq @vm, @vm.fs.first[:__vm]
  end
  def test_cd_no_args_returns_proj_dir
    @vm.cd '/', env:@vm.ios, frames:@vm.fs
    @vm.cd  env:@vm.ios, frames:@vm.fs
    assert_eq @vm.fs[:proj], @vm.fs[:pwd]
  end
  def test_cd_non_existant_dir_does_change_pwd
    @vm.cd '/xxttzz', env:@vm.ios, frames:@vm.fs
    assert_eq @oldpwd, @vm.fs[:pwd]
    @errbuf.reopen
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
    assert_equal "cd: No such file or directory - /v/zzyyxx\n",@errbuf.string  
    @errbuf.reopen
  end
  def test_cd_ok_has_true_exit_status
    @vm.cd '/v', env:@vm.ios, frames:@vm.fs
    assert @vm.fs[:exit_status]
  end
  def test_cd_non_existant_dir_has_false_exit_status
        result = @vm.cd '/v/xxxyyyzzz', env:@vm.ios, frames:@vm.fs
        assert_false result
        @errbuf.reopen
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
    #assert_eq @vm.ios[:out].string.chomp, 'unknown'
#    assert_match /^command: .*: not found: 0/,  @vm.ios[:err].string.chomp
    @errbuf.reopen
  end
  def test_type_returns_false_w_no_match
    result = @vm.type 'jj', env:@vm.ios, frames:@vm.fs
    assert_false result
    @errbuf.reopen
  end
  def test_type_returns_true_w_found
    @vm.fs.aliases['kk'] = 'kk'
    result = @vm.type 'kk', env:@vm.ios, frames:@vm.fs
    assert result
  end
  def test_type_finds_alias
    @vm.fs.aliases['kk'] = 'kk'
    @vm.type 'kk', env:@vm.ios, frames:@vm.fs
    assert_eq @vm.ios[:out].string.chomp[0..4], 'alias'
  end
  def test_type_function_ok
    @vm.fs.functions['fn'] = Function.new([], Block.new([]))
    @vm.type 'fn', env:@vm.ios, frames:@vm.fs
    assert_eq @vm.ios[:out].string.chomp[0..7], 'function'
  end
  def test_type_w_both_names_gives_priority_to_alias
    @vm.fs.functions['fn'] = Function.new([], Block.new([]))
    @vm.fs.aliases['fn'] = 'kk'
    @vm.type 'fn', env:@vm.ios, frames:@vm.fs
    assert_eq @vm.ios[:out].string.chomp[0..4], 'alias'
  end
  def test_type_cd_returns_builtin
    @vm.type 'cd', env:@vm.ios, frames:@vm.fs
    assert_eq @vm.ios[:out].string.chomp[0..6], 'builtin'
  end
  def test_type_w_command_returns_command
    @vm.mkdir '/v/bin', env:@vm.ios, frames:@vm.fs
    @vm.install env:@vm.ios, frames:@vm.fs
    @vm.type 'basename', env:@vm.ios, frames:@vm.fs
    assert_eq @vm.ios[:out].string.chomp, "command\n/v/bin/basename"
  end

end
