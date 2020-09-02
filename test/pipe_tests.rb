# pipe_tests.rb - tests for lib/ast/pipe.rb

require_relative 'test_helper'

class PipeTests < BaseSpike
  def mk_stmnt command, &blk
    stub ordinal: COMMAND, call: command do |o|
      s = Statement.new [ o ]
      yield s if block_given?
    end
  end
  def mk_params left, right, &blk
    mk_stmnt left do |l|
      mk_stmnt right do |r|
        yield l, r if block_given?
      end
    end
  end
  def set_up
    @vm = VirtualMachine.new
    block = Visher.parse! 'mount /v;mkdir /v/bin;install'
    @vm.call block
    @true = True.new
    @false = False.new
  end
  def test_ok
    mk_params 'true', 'true' do |l, r|
      p = Pipe.new l, r
      assert( p.call( env:@vm.ios, frames:@vm.fs))
    end
  end
  def test_false_true_returns_true
    mk_params 'false', 'true' do |l, r|
      p = Pipe.new l, r
      assert( p.call( env:@vm.ios, frames:@vm.fs))
    end
  end
  def test_true_false_returns_false    
    mk_params  'true', 'false' do |l, r|
      p = Pipe.new l, r
    assert_false(p.call(env:@vm.ios, frames:@vm.fs))
    end
  end
  def test_pipe_status_is_length_2
    mk_params 'true', 'true' do |l, r|
      p = Pipe.new l, r
      p.call env:@vm.ios, frames:@vm.fs
      assert_eq @vm.fs[:pipe_status].length, 2
    end
  end
  def k_test_false_true_sets_pipe_status
    mk_params 'false', 'true' do |l, r|
      p = Pipe.new l, r
      p.call env:@vm.ios, frames:@vm.fs
      assert_is @vm.fs[:pipe_status], Array
      assert_false @vm.fs[:pipe_status][0]
      assert @vm.fs[:pipe_status][1]
    end
  end
  def k_test_true_false_has_pipe_status_true_false
    skip 'until fixed'

    p = Pipe.new @true, @false
    p.call env:@vm.ios, frames:@vm.fs
    assert @vm.fs[:pipe_status][0]
    assert_false @vm.fs[:pipe_status][1]
  end
  def test_3_piped_gets_pipe_status_length_3
    mk_params 'true', 'true' do |l, r|
      mk_stmnt 'true' do |t|
        p2 = Pipe.new r, t
        p1 = Pipe.new l, p2
        result = p1.call env:@vm.ios, frames:@vm.fs
        assert result
        assert_eq @vm.fs[:pipe_status].length, 3
        assert_eq @vm.fs[:pipe_status], [ true, true, true ]
      end
    end
  end
end