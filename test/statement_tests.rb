# statement_tests.rb - tests for Statement

require_relative 'test_helper'

class StatementTest < BaseSpike
  def parse string
    b = Visher.parse! string
    b.statement_list.first
  end
  def set_up
    @vm = VirtualMachine.new
    block = Visher.parse! 'mount /v;mkdir /v/bin;install'
    @vm.call block
  end
  def test_stub_works
    stub m: 1 do |o|
      assert_eq o.m, 1
    end
  end
  def test_statement_new
    s = Statement.new [ 'nop' ]
  end
  def test_can_call_call
    stub ordinal: COMMAND, call: nil do |o|
      s = Statement.new [ o ]
    s.call env:@vm.ios, frames:@vm.fs
    end
  end
  def test_call_something_returns_command_name
    stub ordinal: COMMAND, call: 'true' do |o|
      s = Statement.new [ o ]
         s.call env:@vm.ios, frames:@vm.fs
    end
  end
  def test_false_returns_false
    stub ordinal: COMMAND, call: 'false' do |o|
      s = Statement.new [ o ]
      assert_false( s.call( env:@vm.ios, frames:@vm.fs))
    end
    def test_assignment_works
    b = Visher.parse! 'aa=1..3'
    @vm.call b
    c = Visher.parse! 'false'
    assert_false @vm.call c
    end
  end
  def test_redir_is_present
    s = parse 'echo hello > /v/xx'
    assert_eq s.context.map(&:ordinal), [COMMAND, COMMAND, REDIR]
  end
  def test_perform_redirs
    s = parse 'echo hello > /v/xx'
    ctx = s.perform_redirs s.context, env:@vm.ios, frames:@vm.fs
    assert_eq ctx.length, 2
  end
  def test_perform_assigns
    s = parse 'aa=11 echo hello > /v/xx'
    ctx = s.perform_assigns s.context, env:@vm.ios, frames:@vm.fs
    assert_eq ctx.length, 3
  end
  def test_perform_derefs
    s = parse 'echo :prompt'
    ctx = s.perform_derefs s.context, env:@vm.ios, frames:@vm.fs
    assert_eq ctx, ['echo', 'vish', '>']
  end
  def test_perform_all
    s = parse '> /v/xx aa=bb echo :prompt'
    ctx = s.perform_redirs s.context, env:@vm.ios, frames:@vm.fs
    ctx = s.perform_assigns ctx, env:@vm.ios, frames:@vm.fs
    ctx = s.perform_derefs ctx, env:@vm.ios, frames:@vm.fs
    assert_eq ctx, ['echo', 'vish', '>']
  end
end
