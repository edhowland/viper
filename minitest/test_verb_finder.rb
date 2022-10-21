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
  end
  def test_ok
    #
  end
  def test_subclass_alias_finder_can_call_find_method
    vf = VerbFinder::AliasFinder.new
    res = vf.find('shout', vm: @vm)
    assert !res.nil?
    assert (Array === res)
  end
  def test_alias_finder_cammot_find_non_existant_alias
    vf = VerbFinder::AliasFinder.new
    res = vf.find('xyzzy', vm: @vm)
    assert_nil res
  end
  def test_function_finder_finds_foo
    ff = VerbFinder::FunctionFinder.new
    res = ff.find('foo', vm: @vm)
    assert !res.nil?
    assert (Array === res)
  end
  def test_function_finder_canot_find_xyzzy
    ff = VerbFinder::FunctionFinder.new
    assert_nil ff.find('xyzzy', vm: @vm)

  end
  def test_builtin_finder_finds_type
    bf = VerbFinder::BuiltinFinder.new
    res = bf.find('type', vm:@vm)
    assert !res.nil?
  end
  def test_builtin_finder_cannot_find_motme
    bf = VerbFinder::BuiltinFinder.new
    res = bf.find('notme', vm: @vm)
    assert_nil res
    
  end
  def test_command_finder_finds_cat
    cf = VerbFinder::CommandFinder.new
    res = cf.find('cat', vm: @vm)
    assert !res.nil?
        assert (Array === res)
  end
  def test_command_finder_cannot_find_nocmd
    cf = VerbFinder::CommandFinder.new
    res = cf.find('nocmd', vm: @vm)
    assert_nil res
    
  end
  def test_command_finder_finds_cmdlet_bar
    cf = VerbFinder::CommandFinder.new
    res = cf.find('bar', vm: @vm)
    assert !res.nil?
    assert (Array === res)
    assert_eq :command, res[0]
    assert_eq '/v/cmdlet/misc/bar', res[1]
  end
  def test_variable_finder_can_find_path
    varf = VerbFinder.new
    res = varf.find('path', vm: @vm)
    assert !res.nil?
    assert (Array === res)
    assert_eq :variable, res[0]
  end
end
