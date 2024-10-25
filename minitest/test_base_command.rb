# base_command_tests.rb - tests for BaseCommand class and others

require_relative 'test_helper'

class Dummy < BaseCommand
  def call *args, env:, frames:
    arg_error 2, env:env
  end
end

class BaseCommandTests < MiniTest::Test
  def setup
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
    assert_equal @ebuf.string, "dummy: Wrong number of arguments: Expected: 2: Actual: 0\n"
  end
  def test_options_are_empty
    assert_empty @cmd.options
  end
  def test_options_are_empty_w_no_options_in_array
    result = @cmd.args_parse! ['jj', 'kk', 'll']
    assert_empty @cmd.options
    assert_equal result.length, 3
  end
  def test_options_are_set
    result = @cmd.args_parse! ['jj', 'kk', '-e', 'll', '-force']
    assert @cmd.options[:e]
    assert @cmd.options[:force]
    assert_equal result.length, 3
    assert_equal result, ['jj', 'kk', 'll']
  end
  def test_arg_error_with_array
    @cmd.arg_error [0,1,2,3], env:@vm.ios
  end
  def test_arg_error_with_string
    @cmd.arg_error '0 or 1', env:@vm.ios
  end
  def test_message
    @cmd.message stream: :out, env:@vm.ios, sep:' '
  end
  def test_error
    @cmd.error env:@vm.ios
  end
  def test_info
    @cmd.info env:@vm.ios
  end
end
