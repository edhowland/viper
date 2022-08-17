# context_tests.rb - tests for  Statement.context - sort order,
# redirection, assignment, etc.

require_relative 'test_helper'

class ContextTests < MiniTest::Test
  def runit string, vm
    block = Visher.parse! string
    vm.call block
  end
  def get_path vm, path
    root = vm.fs[:vroot]
    root[path]
  end
  def setup
    @vm = VirtualMachine.new
    runit 'mount /v; mkdir /v/bin; install', @vm
    fn = <<-EOS
function for(a, b, c, d, e, f) {
  eq :a i || return false
  eq :b in || return false
  eq :c 0 || return false
  eq :d 1 || return false
  eq :e 2 || return false
  eq :f 3 || return false
  true
}
EOS
    runit fn, @vm
    xx= <<-EOS
function xx() {
  eq :aa 11 || return false
}
EOS
    runit xx, @vm
    jj = <<-EOS
function jj(aa) {
  eq :aa 11 || return false
  return true
}
EOS
    runit jj, @vm
  end
  def test_first_arg_is_zero
    result = runit 'for i in  0 1 2 3', @vm
    assert result
  end
  def test_assignment_works
    result = runit 'aa=11;xx', @vm
    assert result
  end
  def test_assignment_overrides
    result = runit 'aa=11 xx', @vm
    assert result
  end
  def test_assignment_overrides_previous_value
    result = runit 'aa=22; aa=11 xx', @vm
    assert result
  end
  def test_redirection_before_command
    runit '> /v/xx echo hi', @vm
    f = get_path @vm, '/v/xx'
    assert_is f, StringIO
  end
  def test_redir_after_command
    runit 'echo hi > /v/xx', @vm
    f = get_path @vm, '/v/xx'
    assert_is f, StringIO
  end
  def test_variable_deref
    result = runit 'cc=11; jj :cc', @vm
    assert result
  end
end