# glob_tests.rb - tests for Glob

require_relative 'test_helper'


class GlobTests < BaseSpike
  def set_up
    @vm = VirtualMachine.new
    block = Visher.parse! 'mount /v;mkdir /v/bin;install'
    @vm.call block
  end
  def test_ok
    stub call: 'true' do |o|
      g = Glob.new o
      g.call env:@vm.ios, frames:@vm.fs
    end
  end
  def test_star_returns_non_empty_array
    Hal.chdir '/v/bin'
    stub call: '*' do |o|
      g = Glob.new o
      result = g.call env:@vm.ios, frames:@vm.fs
      assert_is result, Array
    end
  end
end