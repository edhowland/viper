# test_verb_finder.rb: tests for class VerbFinder and its inner classes

require_relative 'test_helper'


class TestVerbFinder < MiniTest::Test
  def setup
  
    @vm = VirtualMachine.new
    boot = File.expand_path('../pry/boot.vsh')
    src = File.read(boot)
    block = Visher.parse!(src)
    @vm.call(block)
    src2 = "alias shout='echo'; function foo() { nop }; cmdlet bar '{ out.puts 12 }'"
    b2 = Visher.parse!(src2)
    @vm.call(b2)
    @vf = VerbFinder.new
  end
  def test_ok
    #
  end


  def test_finds_alias
    assert_eq [:alias, 'echo'], @vf.find('shout', vm: @vm)
  end
  def test_does_not_find_alias
    assert_nil @vf.find('zzzyyyxxx', vm: @vm)
  end
  def test_finds_function
    result = @vf.find('foo', vm: @vm)
    assert !result.nil?
    assert_is result, Array
    assert_eq :function, result[0]
  end
  def test_finds_builtin_cd
    result = @vf.find('cd', vm: @vm)
    assert !result.nil?
    assert_is result, Array
    assert_eq [:builtin, 'cd'], result
  end
  def test_can_find_command
    result = @vf.find('cat', vm: @vm)
    assert !result.nil?
    assert_is result, Array
    assert_eq [:command, '/v/bin/cat'], result
  end
  def test_can_find_command_let
    result = @vf.find('bar', vm: @vm)
    assert !result.nil?
    assert_is result, Array
    assert_eq [:command, '/v/cmdlet/misc/bar'], result
  end
  def test_variable_finder_can_find_path_variable
    varf = VerbFinder.new
    res = varf.find('path', vm: @vm)
    assert (Array === res)
    assert_eq :variable, res[0]
  end
end
