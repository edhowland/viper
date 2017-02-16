# virtual_machine_tests.rb - tests for VirtualMachine

require_relative 'test_helper'

class VirtualMachineTests < BaseSpike
  def set_up
    @errbuf = StringIO.new
    @vm = VirtualMachine.new
    @vm.ios[:err] = @errbuf
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
      assert_raises Errno::ENOENT do 
      @vm.cd '/xxttzz', env:@vm.ios, frames:@vm.fs
    end
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
end
