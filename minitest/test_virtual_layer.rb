# virtual_layer_tests.rb - tests for VirtualLayer 

require_relative 'test_helper'

class VirtualLayerTests < MiniTest::Test
  def setup
    @vm = VirtualMachine.new
    @vm.mount '/v', env:@vm.ios, frames:@vm.fs
    @vroot = @vm.fs[:vroot]    
    Hal.chdir '/v'
    @wd = @vroot.wd
  end
  def test_chdir_ok
    VirtualLayer.chdir '/v'
  end
  def test_exist_true_for_dot
    assert VirtualLayer.exist?('.')
  end
  def test_chdir_bad_raises_Errno
        assert_raises Errno::ENOENT do 
      VirtualLayer.chdir '/v/xxx/ttt/ggg'
    end 
  end
  def test_chdir_dot_ok
    VirtualLayer.chdir('/v')
    VirtualLayer.chdir('..')
  end
  def test_touch
    VirtualLayer.touch '/v/aa'
    assert VirtualLayer.exist? '/v/aa'
  end
  def test_cp_dir
    VirtualLayer.touch '/v/file'
    VirtualLayer.mkdir_p '/v/zzz'
    VirtualLayer.cp '/v/file', '/v/zzz'
    assert VirtualLayer.exist?('/v/zzz/file'), 'Expected /v/zzz/file to exist'
  end
  def test_cp_file_to_non_existant_file
    VirtualLayer.touch 'file'
    VirtualLayer.cp 'file', 'thing'
    assert VirtualLayer.exist?('/v/thing'), 'expected /v/thing to exist'
  end
  def test_cp_file_to_existing_object
    file = VirtualLayer.touch 'file'
    #old = 
    VirtualLayer.touch 'old'
    file.print 'hello'
    file.rewind
    assert_equal file.string, 'hello'
    VirtualLayer.cp 'file', 'old'
    new_file = @vroot['/v/old']
    new_file.rewind
    contents = new_file.string
    assert_equal contents, 'hello'
  end
  def test_mv_w_full_path
    VirtualLayer.touch '/v/aa'
    VirtualLayer.mkdir_p '/v/xxx'
    VirtualLayer.mv '/v/aa', '/v/xxx'
    assert VirtualLayer.exist?('/v/xxx/aa')
  end
  def test_mv_w_relative_path
    VirtualLayer.touch 'jj'
    VirtualLayer.mv 'jj', 'kk'
    assert VirtualLayer.exist?('/v/kk'), 'Expected VirtualLayer.mv to move /v/jj to /v/kk'
    assert_false VirtualLayer.exist?('/v/jj')
  end
  def test_cp_same_file_raises_argument_error_same_file
    VirtualLayer.touch 'x'
    assert_raises ArgumentError do 
      VirtualLayer.cp 'x', 'x'
    end
  end
  def test_cp_non_existant_file_raises_no_such_file
    assert_raises Errno::ENOENT  do
      VirtualLayer.cp 'zzyyx', 'xxyyz'
    end
  end
  def test_rm_works_w_full_path
    VirtualLayer.touch '/v/xx'
    assert VirtualLayer.exist?('/v/xx'), 'Expected VirtualLayer.touch to create file'
    VirtualLayer.rm '/v/xx'
        assert_false VirtualLayer.exist?('/v/xx')
  end
  def test_rm_w_relative_path_removes_file
    VirtualLayer.touch 'xx'
    assert VirtualLayer.exist?('xx'), 'Expected VirtualLayer.touch to create file'
    VirtualLayer.rm 'xx'
    assert_false VirtualLayer.exist?('xx')
  end
  def test_directory
    assert VirtualLayer.directory?('/v')
  end
  def test_directory_with_trailing_slash
    assert VirtualLayer.directory?('/v/')
  end
  def test_directory_w_inner_dir_w_trailing_slash
    VirtualLayer.mkdir_p('/v/foo/bar')
    assert VirtualLayer.directory?('/v/foo/bar/')
  end
  def test_directory_inner_directory
    VirtualLayer.mkdir_p('/v/dir')
    assert VirtualLayer.directory?('/v/dir')
  end
  def test_directory_dot_dot_is_true
    VirtualLayer.mkdir_p('/v/dir/foo/bar')
    VirtualLayer.chdir('/v/dir/foo/bar')
    assert VirtualLayer.directory?('..')
  end
  def test_directory_dot_is_true
        VirtualLayer.mkdir_p('/v/dir/foo/bar')
    VirtualLayer.chdir('/v/dir/foo/bar')
    assert VirtualLayer.directory?('.')
  end
  def test_realpath
    VirtualLayer.mkdir_p '/v/dir/foo/bar'
    assert_equal '/v/dir/foo/bar', VirtualLayer.realpath('/v/dir/foo/bar/')
  end
  def test_realpath_works_for_dot_dot
    VirtualLayer.mkdir_p '/v/dir/foo/bar'
    VirtualLayer.chdir '/v/dir/foo/bar'
    assert_equal '/v/dir/foo', VirtualLayer.realpath('..')
  end
  def test_relative_is_true_for_foo_bar
    assert VirtualLayer.relative?('foo/bar')
  end
  def test_relative_is_false_for_absolute_path
    assert !VirtualLayer.relative?('/v/foo/bar')
  end
end
