# context_tests.rb - tests for  Statement.context - sort order,
# redirection, assignment, etc.

require_relative 'test_helper'

class ContextTests < BaseSpike
  def run string, vm
    block = Visher.parse! string
    vm.call block
  end
  def get_path vm, path
    root = vm.fs[:vroot]
    root[path]
  end
  def set_up
    @vm = VirtualMachine.new
    run 'mount /v; mkdir /v/bin; install', @vm
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
    run fn, @vm
    xx= <<-EOS
function xx() {
  eq :aa 11 || return false
}
EOS
    run xx, @vm
  end
  def test_first_arg_is_zero
    result = run 'for i in  0 1 2 3', @vm
    assert result
  end
  def test_assignment_works
    result = run 'aa=11;xx', @vm
    assert result
  end
  def test_assignment_overrides
    result = run 'aa=11 xx', @vm
    assert result
  end
  def test_assignment_overrides_previous_value
    result = run 'aa=22; aa=11 xx', @vm
    assert result
  end
  def test_redirection_before_command
    run '> /v/xx echo hi', @vm
    f = get_path @vm, '/v/xx'
    assert_is f, StringIO
  end
  def test_redir_after_command
    run 'echo hi > /v/xx', @vm
    f = get_path @vm, '/v/xx'
    assert_is f, StringIO
  end
end