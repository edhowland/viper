# glob_tests.rb - tests for Glob

require_relative 'test_helper'

class StubDummy
  def self.call(*args)
    #
  end
end

class GlobTests < MiniTest::Test
  def setup
    @vm = VirtualMachine.new
    block = Visher.parse! 'mount /v;mkdir /v/bin;install'
    @vm.call block
  end
  def test_ok
    StubDummy.stub(:call, 'true') do |o|
      g = Glob.new o
      g.call env:@vm.ios, frames:@vm.fs
    end
  end
  def test_glob_in_physical_layer_path_slash_star_returns_non_empty_array
    vhome = @vm.fs[:vhome]
    Hal.chdir(vhome)
    StubDummy.stub(:call, 'etc/*') do |o|
      g = Glob.new o
      result = g.call env:@vm.ios, frames:@vm.fs
      assert_is result, Array
      assert !result.empty?
    end
  end
  def test_physical_works_w_brackets
    vhome = @vm.fs[:vhome]
    StubDummy.stub(:call, 'scripts/00[12]_*') do |o|
      result = g.call env: @vm.ios, frames: @vm.fs
      assert !result.empty?
      assert_eq 2, result.length
    end
  end
  def test_physical_works_w_question
      vhome = @vm.fs[:vhome]
    StubDummy.stub(:call, 'scripts/???_*') do |o|
      g = Glob.new(o)
      result = g.call env: @vm.ios, frames: @vm.fs
      assert !result.empty?
    end
  

  end
  def test_star_returns_non_empty_array
    Hal.chdir '/v/bin'
    StubDummy.stub :call, '*' do |o|
      g = Glob.new o
      result = g.call env:@vm.ios, frames:@vm.fs
      assert_is result, Array
      assert !result.empty?
      assert result.length > 1
    end
  end
  def test_virtual_layer_w_path_star_returns_non_empty_array
    Hal.chdir('/v/')
    StubDummy.stub(:call, 'bin/*') do |o|
      g = Glob.new o
      result = g.call env:@vm.ios, frames:@vm.fs
      assert_is result, Array
      assert !result.empty?
      assert result.length > 1
    end
  end
end