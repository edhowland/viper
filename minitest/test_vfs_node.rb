# test_vfs_node.rb: tests for VFSNode

require_relative 'test_helper'


class TestVfsNode < MiniTest::Test
  def setup
    @vm = VirtualMachine.new
    @vm.mount '/v', env:@vm.ios, frames:@vm.fs
    @vroot = @vm.fs[:vroot]
  end
  def test_pathname
    VirtualLayer.mkdir_p '/v/dir/foo/bar'
    VirtualLayer.chdir '/v/dir/foo/bar'
    vnode = @vroot.wd
    assert_equal '/v/dir/foo/bar', vnode.pathname
    
  end
  def test_vfs_node_elements_is_array_and_matches
    VirtualLayer.mkdir_p '/v/dir/foo/bar'
    VirtualLayer.chdir '/v/dir/foo/bar'
    vnode = @vroot.wd
    res = vnode.elements
    assert_is res, Array
    assert_equal ['', 'v', 'dir', 'foo', 'bar'], res
  end
end