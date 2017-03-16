# base_command_tests.rb - tests for BaseCommand class and others

require_relative 'test_helper'

class Dummy < BaseCommand
  def call *args, env:, frames:
    arg_error 2, env:env
  end
end

class BaseCommandTests < BaseSpike
  def set_up
    @ebuf = StringIO.new
    @vm = VirtualMachine.new
    @vm.ios[:err] = @ebuf
    @vm.mount '/v', env:@vm.ios, frames:@vm.fs
    @vm.mkdir '/v/bin', env:@vm.ios, frames:@vm.fs
    @vm.install env:@vm.ios, frames:@vm.fs
    @cmd = Dummy.new

  end
  def test_create
  end
  def test_arg_error
    @cmd.call env:@vm.ios, frames:@vm.fs
    assert_diff @ebuf.string, "dummy: Wrong number of arguments: Expected: 2\n"
  end
  def test_error
    @cmd.error env:@vm.ios
  end
end
