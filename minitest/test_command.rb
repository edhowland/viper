# command_tests.rb - tests for 

require_relative 'test_helper'

class CommandTests < MiniTest::Test
  def setup
    @vm = VirtualMachine.new
    @vm.mount '/v', env:@vm.ios, frames:@vm.fs
    @vm.mkdir '/v/bin', env:@vm.ios, frames:@vm.fs
    @vm.install env:@vm.ios, frames:@vm.fs
    @vm.mkdir '/v/cmdlet', env:@vm.ios, frames:@vm.fs
    @root = @vm.fs[:vroot]
  end
  def test_root_is_vroot
    assert !@root.nil?
    assert_is @root, VFSRoot
  end
  def test_command_has_path_string_and_is_not_empty
    assert_is Command.path_str(frames: @vm.fs), String
    assert !Command.path_str(frames: @vm.fs).empty?
  end
  def test_first_in_path_is_found
    result = Command.first_in_path('cat', frames: @vm.fs)
    assert !result.nil?
    #assert result.kind_of?(BaseCommand)
  end
  def test_resolve_echo
    result = Command.resolve 'echo', env:@vm.ios, frames:@vm.fs
    assert_is result, Echo
  end
  def test_normal_command_is_found_in_v_bin
    result = Command.first_in_path 'cat', frames: @vm.fs
    assert_eq result, '/v/bin/cat'
  end
  def test_get_command_from_path_search_normal_path
    skip
    result = Command.command_from_path Command.first_in_path('cat', frames: @vm.fs), frames: @vm.fs
    assert_is Cat, result
  end
  def test_first_in_path_w_2_paths_is_still_found
        @vm.fs.first[:path] = '/v/cmdlet:/v/bin'
    @root.creat '/v/cmdlet/ord', CommandLet.new
    result = Command.first_in_path 'ord', frames: @vm.fs
    assert_eq result, '/v/cmdlet/ord'
        
#
  end
  def test_command_resolves_to_v_bin
    skip
    @vm.fs.first[:path] = '/v/cmdlet:/v/bin'
    @root.creat '/v/cmdlet/ord', CommandLet.new
    result = Command.resolve('ord', env: @vm.ios, frames: @vm.fs)
    assert_is result, CommandLet
  end
end
