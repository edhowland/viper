# vfs_tests.rb - tests for  VFS

require_relative 'test_helper'

class VFSTest < BaseSpike
  def set_up
    @vm = VirtualMachine.new
    @vm.mount '/v', env:@vm.ios, frames:@vm.fs
    @vroot = @vm.fs[:vroot]
  end
  def test_normal_open
    Hal.chdir File.dirname(__FILE__)
    Hal.open __FILE__, 'r'
  end
  def test_virtual_layer
    Hal.open '/v/xxx', 'w'
  end
  def test_open_non_existant_raises_errno
    assert_raises Errno::ENOENT do 
      Hal.open 'xyzzy', 'r'
    end
  end
  def test_non_existant_long_path
        assert_raises Errno::ENOENT do 
          Hal.open 'tmp/a/b/c/d/hello', 'r'
        end
  end
  def test_open_vfs_ok
    Hal.open '/v', 'r'
  end
  def test_vfs_non_existant_file_raises
    assert_raises Errno::ENOENT do 
      Hal.open '/v/xxx', 'r'
    end
  end
  def test_vfs_non_existant_long_path_raises
    assert_raises Errno::ENOENT do
      Hal.open '/v/xxx/yyy/zzz/hello', 'r'
    end
  end
  def test_vfs_root_one_level_path_returns_nil
    assert @vroot['/v/xxxyyyzzz'].nil?, 'Expected VFSRoot to return nil, but it did not'
  end
  def test_vroot_returns_nil_given_2_or_more_non_existant_paths
    #assert @vroot['/v/xxx/ttt'], 'Expected VFSRoot to return nil, but it did not'
    assert_is @vroot['/v/xxx/yyy/zzz'], NilClass
  end
end
