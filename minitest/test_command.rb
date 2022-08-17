# command_tests.rb - tests for 

require_relative 'test_helper'

class CommandTests < MiniTest::Test
  def setup
    @vm = VirtualMachine.new
    @vm.mount '/v', env:@vm.ios, frames:@vm.fs
    @vm.mkdir '/v/bin', env:@vm.ios, frames:@vm.fs
    @vm.install env:@vm.ios, frames:@vm.fs
  end
  def test_resolve_echo
    result = Command.resolve 'echo', env:@vm.ios, frames:@vm.fs
    assert_is result, Echo
  end
end