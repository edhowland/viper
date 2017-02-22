# virtual_layer_tests.rb - tests for VirtualLayer 

require_relative 'test_helper'


class VirtualLayerTests < BaseSpike
  def set_up
    @vm = VirtualMachine.new
    @vm.mount '/v', env:@vm.ios, frames:@vm.fs
    @vroot = @vm.fs[:vroot]    
  end
  def test_chdir_ok
    VirtualLayer.chdir '/v'
  end
  def test_chdir_bad_raises_Errno
        assert_raises Errno::ENOENT do 
      VirtualLayer.chdir '/v/xxx/ttt/ggg'
    end 
  end
end
