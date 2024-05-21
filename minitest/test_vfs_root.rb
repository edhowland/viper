# test_vfs_root.rb: tests for VFSRoot

require_relative 'test_helper'


class TestVfsRoot < MiniTest::Test
  def setup
    @vm = VirtualMachine.new
    @vm.mount '/v', env:@vm.ios, frames:@vm.fs
    @vroot = @vm.fs[:vroot]
  end
  def my_mkdir(path)
    VirtualLayer.mkdir_p(path)
  end
  def my_chdir(path)
    @vm.cd(path, env: @vm.ios, frames: @vm.fs)
  end

  def test_relative_is_true
    assert @vroot.relative?('foo/bar')
  end
  def test_relative_is_false_for_absolute_path
    assert !@vroot.relative?('/v/buf')
  end
  def test_relative_dot_is_true
    assert @vroot.relative?('.')
  end
  def test_relative_dot_dot_path_is_true
    assert @vroot.relative?('../foo/bar')
  end
  def test_resolve_path_w_absolute_path
    assert_equal '/v/foo/bar/baz', @vroot.resolve_path('/v/foo/bar/baz')
  end
  def test_resolve_path_w_relative_path_is_absolute
    VirtualLayer.mkdir_p('/v/foo/bar/baz')
    my_chdir('/v/foo')
    assert_equal '/v/foo/bar/baz', @vroot.resolve_path('bar/baz')
  end
  def test_resolve_path_path_w_relative_longer_path
    VirtualLayer.mkdir_p('/v/rum/rye/gin/scotch')
    my_chdir('/v/rum/rye/')
    assert_equal '/v/rum/rye/gin/scotch', @vroot.resolve_path('gin/scotch')
  end
  def test_resolve_path_w_dot_and_absolute_path_removes_dot
    VirtualLayer.mkdir_p('/v/jjj/kkk/lll/mmm/nnn/ooo/ppp')
    my_chdir('/v/jjj/kkk/lll')
    assert_equal '/v/jjj/kkk/lll/mmm/nnn', @vroot.resolve_path('/v/jjj/kkk/lll/./mmm/nnn')
  end
  def test_resolve_path_w_dot_at_end_does_not_becomes_current_folder
  full = '/v/aaa/bbb/ccc/ddd'
    VirtualLayer.mkdir_p full
    my_chdir full
    assert_equal '/v/aaa/bbb/ccc', @vroot.resolve_path('/v/aaa/bbb/ccc/.')
  end
  def test_resolve_path_dot_becomes_pwd
    VirtualLayer.mkdir_p('/v/zzz/yyy/xxx')
    my_chdir('/v/zzz/yyy/xxx')
    assert_equal '/v/zzz/yyy/xxx', @vroot.resolve_path('.')
  end
  def test_resolve_path_dot_dot_returns_parent_pwd
    VirtualLayer.mkdir_p '/v/grand/parent/child'
    my_chdir '/v/grand/parent/child'
    assert_equal '/v/grand/parent',  @vroot.resolve_path('..')
  end
  def test_resolve_path_w_dup_slashes_removes_them
    my_mkdir '/v/dir/goo/jam/kat'
    my_chdir '/v/dir/goo/jam/kat'
    assert_equal '/v/dir/goo/jam/kat', @vroot.resolve_path('/v/dir/goo//jam///kat')
  end
end
