# ast_tests.rb - tests for  AstTests

require_relative 'test_helper'

class AstTests < MiniTest::Test
  def setup
    @vm = VirtualMachine.new
    b=Visher.parse! 'mount /v;mkdir /v/bin;install'
    @vm.call b
  end
  def test_sub_shell_sets_exit_status
    b=Visher.parse! '(false)'
    result = @vm.call b
    assert_false result
  end
end

