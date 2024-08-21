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
  def test_all_types_of_subshell_equality
    b = Visher.parse! '(pwd)'
    c = Visher.parse! '(pwd)'
    assert_eq b.statement_list.first, c.statement_list.first

  end
  def test_deref_equivalence
    b = Visher.parse! 'echo :foo'
    c = Visher.parse! 'echo :foo'
    assert_eq b.statement_list.first.context[1], c.statement_list.first.context[1]   # this is actuall argument, but the == goes thru to Deref

  end
  def test_lazy_argument_equality
    b = Visher.parse! 'exec { pwd }'
    c = Visher.parse! 'exec { pwd }'
    assert_eq b.statement_list.first.context[1], c.statement_list.first.context[1]

  end
  def test_statement_equality
    b = Visher.parse! 'echo :a foo baz'
    c = Visher.parse! 'echo :a foo baz'
    assert_eq b.statement_list.first, c.statement_list.first

  end
end

