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
  def test_assignment_equality
    b=Visher.parse! 'a=1'
    c=Visher.parse! 'a=1'
    assert_eq b.statement_list.first.context.first, c.statement_list.first.context.first

  end

  def test_alias_decls_are_equal
    b=Visher.parse! 'alias foo="bar"'
    c=Visher.parse! 'alias foo="bar"'
    assert_eq b.statement_list.first, c.statement_list.first
  end
  def test_equality_for_function_decl
    b=Visher.parse! 'function baz(a, b, c) { pwd }'
    c=Visher.parse! 'function baz(a, b, c) { pwd }'
    assert_eq b.statement_list.first, c.statement_list.first

  end
  def test_redirection_equality_stdin
    b=Visher.parse! 'cat < foo.txt'
    c=Visher.parse! 'cat < foo.txt'
    assert_eq b.statement_list.first.context[1], c.statement_list.first.context[1]
  end

  def test_redirection_equality_stdout
    b=Visher.parse! 'cat > foo.txt'
    c=Visher.parse! 'cat > foo.txt'
    assert_eq b.statement_list.first.context[1], c.statement_list.first.context[1]
  end
  
  def test_redirection_equality_append
    b=Visher.parse! 'cat >> foo.txt'
    c=Visher.parse! 'cat >> foo.txt'
    assert_eq b.statement_list.first.context[1], c.statement_list.first.context[1]
  end
end

