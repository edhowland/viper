# glob_tests.rb - tests for Glob

require_relative 'test_helper'



class GlobTests < MiniTest::Test
  def setup
    @vm = VirtualMachine.new
    block = Visher.parse! 'mount /v;mkdir /v/bin;install'
    @vm.call block
  end
  def test_ok
      g = Glob.new QuotedString.new('true')
      g.call env:@vm.ios, frames:@vm.fs
  end
  def test_glob_in_physical_layer_path_slash_star_returns_non_empty_array
    vhome = @vm.fs[:vhome]
    Hal.chdir(vhome)
      g = Glob.new QuotedString.new('local/*')
      result = g.call env:@vm.ios, frames:@vm.fs
$stderr.puts "result: #{result.class.name}"
      assert_is result, Array
      assert !result.empty?
  end
  def test_physical_works_w_brackets
    vhome = @vm.fs[:vhome]
    Hal.chdir(vhome)

      g = Glob.new QuotedString.new('local/viper/modules/edit/00[12]_*.vsh')
      result = g.call env: @vm.ios, frames: @vm.fs
      assert !result.empty?
      assert_eq 2, result.length
  end
  def test_physical_works_w_question
      g = Glob.new(QuotedString.new('scripts/???_*'))
      result = g.call env: @vm.ios, frames: @vm.fs
      assert !result.empty?
  

  end
  def test_star_returns_non_empty_array
    Hal.chdir '/v/bin'
      g = Glob.new QuotedString.new('*')
      result = g.call env:@vm.ios, frames:@vm.fs
      assert_is result, Array
      assert !result.empty?
      assert result.length > 1
  end
  def test_virtual_layer_w_path_star_returns_non_empty_array
    Hal.chdir('/v/')
      g = Glob.new QuotedString.new('bin/*')
      result = g.call env:@vm.ios, frames:@vm.fs
      assert_is result, Array
      assert !result.empty?
      assert result.length > 1
  end
end