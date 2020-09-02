# buf_node_tests.rb - tests for  BufNode - subclass of VFSNode directory

require_relative 'test_helper'

class BufNodeTests < BaseSpike
  def set_up
    @vm = VirtualMachine.new
    @vm.mount '/v', env:@vm.ios, frames:@vm.fs
    @vm.mkdir '/v/buf', env:@vm.ios, frames:@vm.fs
    @vroot = @vm.fs[:vroot]
    @mkbuf = Mkbuf.new
  end
  def test_creation
    result = @mkbuf.call '/v/buf/xxx', env:@vm.ios, frames:@vm.fs
    assert result, 'expected result of mkbuf creation to be true'
    node = @vroot['/v/buf/xxx']
    assert_is node, BufNode
    buffer = node['buffer']
    assert_is buffer, Buffer
   end
   def test_deep_clone_creates_cloned_object
         result = @mkbuf.call '/v/buf/xxx', env:@vm.ios, frames:@vm.fs
    node = @vroot['/v/buf/xxx']
         cnode =  node.deep_clone
         assert_neq cnode.object_id, node.object_id
   end
end