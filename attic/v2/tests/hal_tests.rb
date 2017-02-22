# hal_test.rb - tests for Hal - chdir, virtual?, others

require_relative 'test_helper'

class HalTest < BaseSpike
    def set_up
    @vm = VirtualMachine.new
    @vm.mount '/v', env:@vm.ios, frames:@vm.fs
    @vroot = @vm.fs[:vroot]
    @oldpwd = @vm.fs[:pwd]
  end
  def tear_down
    Hal.chdir @oldpwd, @vm.fs[:pwd]
  end
  def test_mkdir_ok
    Hal.mkdir_p '/v/a/b'
  end
  def test_chdir_ok
    Hal.mkdir_p '/v/a/b'
    Hal.chdir '/v/a/b', @vm.fs[:pwd]
  end
  def test_chdir_non_existant_path_raises_no_file_or_dir
        Hal.mkdir_p '/v/a/b'
            assert_raises Errno::ENOENT do 
      Hal.chdir '/v/a/c', @vm.fs[:pwd]
    end
  end
  def test_physical_chdir_works
    Hal.chdir '..', @vm.fs[:pwd]#
  end
  def test_chdir_non_existant_physical_raises_no_such_file_or_dir
            assert_raises Errno::ENOENT do 
              Hal.chdir '/xxtt/zzz', @vm.fs[:pwd]
            end 
    
  end
end
