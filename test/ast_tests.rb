# ast_tests.rb - tests for lib/ast/*.rb

require_relative 'test_helper'

class AstTests < BaseSpike
  def set_up
    @vm = VirtualMachine.new
    @true = True.new
    @false = False.new
  end
  def test_ok
    p = Pipe.new @true, @true
    assert( p.call( env:@vm.ios, frames:@vm.fs))
  end
  def test_false_true_returns_true
        p = Pipe.new @false, @true
    assert( p.call( env:@vm.ios, frames:@vm.fs))
  end
  def test_true_false_returns_false
    p = Pipe.new @true, @false
    assert_false(p.call(env:@vm.ios, frames:@vm.fs))
  end
  def test_false_true_sets_pipe_status
    p = Pipe.new @false, @true
    p.call env:@vm.ios, frames:@vm.fs
    assert_is @vm.fs[:pipe_status], Array
    assert_false @vm.fs[:pipe_status][0]
    assert @vm.fs[:pipe_status][1]
  end
  def test_true_false_has_pipe_status_true_false
    p = Pipe.new @true, @false
    p.call env:@vm.ios, frames:@vm.fs
    assert @vm.fs[:pipe_status][0]
    assert_false @vm.fs[:pipe_status][1]
  end
  def test_3_piped_gets_pipe_status_length_3
    p2 = Pipe.new @false, @true
    p1 = Pipe.new @true, p2
    result = p1.call env:@vm.ios, frames:@vm.fs
    assert result
    assert_eq @vm.fs[:pipe_status].length, 3
  end
end