# statement_tests.rb - tests for Statement

require_relative 'test_helper'

class NullException < RuntimeError
end

class OldMocker
  def initialize
    @expects = []
  end
  attr_reader :expects

  def verify!
    assert @expects.empty?, 'Mock expectation error'
    true
  end

  def expect name, *args, **keywords, &blk
    @expects << [name, args, keywords, blk]
  end
  
  def method_missing name, *args, **keywords
  was = @expects.shift
  assert !was.nil?, 'No expectations set'
  assert (was[0] == name && was[1] == args && was[2] == keywords), "Unexpected #{name} called with #{args} and #{keywords}"
  was[3].call if was[3].instance_of? Proc
  end
end
class StatementTest < MiniTest::Test
  def parse string
    b = Visher.parse! string
    b.statement_list.first
  end
  def arg_stub(ord, cmd, &blk)
    arg = Argument.new('foo')
    arg.stub(:ordinal, ord) do
      arg.stub(:call, cmd) do
        blk.call(arg)
      end
    end
  end
  def qs str
    QuotedString.new(str)
  end

  def setup
    @vm = VirtualMachine.new
    block = Visher.parse! 'mount /v;mkdir /v/bin;install'
    @vm.call block
  end
  attr_accessor :vm

  def test_statement_new
    _ = Statement.new [ 'nop' ]
  end
  def test_can_call_call
    arg_stub(COMMAND, nil) do |o|
      s = Statement.new [ o ]
    s.call env:@vm.ios, frames:@vm.fs
    end
  end
  def test_call_something_returns_command_name
    arg_stub(COMMAND, 'true') do |o|
      s = Statement.new [ o ]
         s.call env:@vm.ios, frames:@vm.fs
    end
  end
  def test_false_returns_false
    arg_stub(COMMAND, 'false') do |o|
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
    assert_equal s.context.map(&:ordinal), [COMMAND, COMMAND, REDIR]
  end
  def test_bump_frames_push_frames
    s = Statement.new
    cur_ios_len = @vm.ios.length
    cur_fs_len = @vm.fs.length
    s.bump_frames env:@vm.ios, frames:@vm.fs do |ios, fs|
      assert_equal ios.length, (cur_ios_len + 1)
      assert_equal fs.length, (cur_fs_len + 1)
    end
  end
  def test_bump_frames_pops_after_call
    s = Statement.new
    cur_ios_len = @vm.ios.length
    cur_fs_len = @vm.fs.length
    begin
      s.bump_frames env:@vm.ios, frames:@vm.fs do |ios, fs|
      fail 'bad juju'
    end
    rescue => _err
    end
    assert_equal @vm.ios.length, cur_ios_len
    assert_equal @vm.fs.length, cur_fs_len

  end
  def test_bump_frames_returns_result_of_block
    s = Statement.new
    result = s.bump_frames env:@vm.ios, frames:@vm.fs do |ios, fs|
      99
    end
    assert_equal result, 99
  end
  def test_wrap_streams
    s = Statement.new
    result = s.bump_frames env:@vm.ios, frames: @vm.fs do |ios, fs|
      s.wrap_streams env:ios, frames:fs do |ios, fs|
      55
      end
    end
      assert_equal result, 55
  end
  def test_wrap_streams_w_exception_closes_streams
    s = Statement.new
    fin = MiniTest::Mock.new
    fin.expect :close, nil
    m = MiniTest::Mock.new
    m.expect(:open, fin)
    fout = MiniTest::Mock.new
    fout.expect(:close, nil)
    mout = MiniTest::Mock.new
    mout.expect(:open, fout)
    ferr = MiniTest::Mock.new
    ferr.expect :close, nil
    merr = MiniTest::Mock.new
    merr.expect(:open, ferr)
    begin
      s.bump_frames env:@vm.ios, frames:@vm.fs do |ios, fs|
      ios[:in] = m
      ios[:out] = mout
      ios[:err] = merr
      s.wrap_streams env:ios, frames:fs do |ios, fs|
        raise NullException.new
      end
    end
    rescue NullException  => _err
    end
    fin.verify
    m.verify
    mout.verify
    fout.verify
    merr.verify
    ferr.verify
  end
  def test_perform_redirs
    s = parse 'echo hello > /v/xx'
    ctx = s.perform_redirs s.context, env:@vm.ios, frames:@vm.fs
    assert_equal ctx.length, 2
  end
  def test_perform_assigns
    s = parse 'aa=11 echo hello > /v/xx'
    ctx = s.perform_assigns s.context, env:@vm.ios, frames:@vm.fs
    assert_equal ctx.length, 3
  end
  def test_perform_derefs
    s = parse 'echo :prompt'
    ctx = s.perform_derefs s.context, env:@vm.ios, frames:@vm.fs
    assert_equal ctx, ['echo', 'vish', '>']
  end
  def test_perform_all
    s = parse '> /v/xx aa=bb echo :prompt'
    ctx = s.perform_redirs s.context, env:@vm.ios, frames:@vm.fs
    ctx = s.perform_assigns ctx, env:@vm.ios, frames:@vm.fs
    ctx = s.perform_derefs ctx, env:@vm.ios, frames:@vm.fs
    assert_equal ctx, ['echo', 'vish', '>']
  end
  def test_prepare
    s = parse 'echo hello > :aa'
    @vm.fs[:aa] = '/v/xx'
    ctx = s.prepare s.context, env:@vm.ios, frames:@vm.fs
    assert_equal ctx, ['echo', 'hello']
  end
  def test_execute
    s = parse 'echo hello'
    result = s.execute env:@vm.ios, frames:@vm.fs
    assert result
  end
  def test_execute_returns_false
    s = parse 'false'
    result = s.execute env:@vm.ios, frames:@vm.fs
    assert_false result
  end
  def test_execute_sets_exit_status
    s = parse 'false'
    s.execute env:@vm.ios, frames:@vm.fs
    assert_false @vm.fs[:exit_status]
    assert_equal @vm.fs[:pipe_status], [false]
  end
  def test_execute_w_assignments
    s = parse 'aa=bb nop'
    @vm.fs[:aa] = ''
    s.execute env:@vm.ios, frames:@vm.fs
    assert_equal @vm.fs[:bb], ''
  end
  def test_execute_w_local_assigns_can_globalize_them
    s = parse 'aa=bb global aa'
        s.execute env:@vm.ios, frames:@vm.fs
        assert_equal @vm.fs[:aa], 'bb'
  end
  def test_execute_w_redir_to_stdout
    s = parse '> /v/xx echo hello'
            s.execute env:@vm.ios, frames:@vm.fs
    vroot = @vm.fs[:vroot]
    assert_equal vroot['/v/xx'].string, "hello\n"

  end
  def test_command_ndx
    s = parse 'echo hello'
    assert_equal s.command_ndx, 0
  end
  def test_command_ndx_w_preceeding_stuff
    s = parse 'aa=bb > xx echo hello'
    assert_equal s.command_ndx, 2
  end
  def test_command_ndx_w_no_command_returns_nil
    s = parse 'aa=bb'
    assert_nil s.command_ndx
  end
  def test_has_alias_is_false_when_no_command
    s = parse 'aa=bb'
    assert_false s.has_alias?(frames:@vm.fs)
  end
  def test_has_alias_w_command_is_not_aliased
    s = parse 'aa=bb > xx echo hello'
    assert_false s.has_alias?(frames:@vm.fs)
  end
  def test_has_alias_w_aliased_e_is_echo
    @vm.fs.aliases['e'] = 'echo'
    s = parse 'e hello'
    assert s.has_alias?(frames:@vm.fs)
  end
  def test_doit_w_true_returns_true
    s = parse 'true'
    result = s.call env:@vm.ios, frames: @vm.fs
    assert result
  end
  def test_alias_f_false_seen_w_has_alias
        @vm.fs.aliases['f'] = 'false'
    s = parse 'f'
    assert s.has_alias?(frames: @vm.fs)
  end
  def test_expand_laias_w_f_false
            @vm.fs.aliases['f'] = 'false'
    s = parse 'f'
    result = s.expand_alias(frames: @vm.fs)
    assert_equal result, 'false'
  end
  def test_expand_alias_w_complicated_expansion
    @vm.fs.aliases['nonce'] = 'echo hello; echo world'
    s = parse 'nonce'
    result = s.expand_alias(frames: @vm.fs)
    assert_equal result, 'echo hello; echo world'
  end
  def test_embed_alias_returns_new_statement_string
    @vm.fs.aliases['e'] = qs 'echo'
    s = parse '< xx aa=bb > yy e hello'
    result = s.embed_alias(frames: @vm.fs)
    assert_equal result, '< xx aa=bb > yy echo hello'
  end
  def test_embed_alias_w_multi_statement_alias
    @vm.fs.aliases['c'] = qs 'cat | cat >'
    s = parse  '< xx c vv'
    result = s.embed_alias(frames: @vm.fs)
    assert_equal result, '< xx cat | cat > vv'
  end
  def test_expand_and_call
    @vm.fs.aliases['f'] = qs 'false'
    s = parse 'f'
    result = s.expand_and_call(env: @vm.ios, frames: @vm.fs)
    assert_false result
  end
  def test_expand_and_call_w_non_recursive_alias
    @vm.fs.aliases['foo'] = qs 'bar'
    @vm.fs.aliases['bar'] = qs 'baz'
    @vm.fs.aliases['baz'] = qs 'nop'
    s = parse 'foo'
    result = s.expand_and_call(env: @vm.ios, frames:@vm.fs)
    assert result
  end
  def test_execute_w_function_declaration
        blk = Visher.parse! 'function baz() { return false }'
    @vm.call blk
    s = parse 'baz'
    result = s.execute(env: @vm.ios, frames: @vm.fs)
    assert_false result
  end
  def test_foo_alias_to_baz_is_a_function
            blk = Visher.parse! 'function baz() { return false }'
    @vm.call blk
    @vm.fs.aliases['foo'] = qs 'baz'
    s = parse 'foo'
    result = s.has_alias?(frames: @vm.fs)
    assert result
    result = s.call(env: @vm.ios, frames: @vm.fs)
    assert_false result
  end
  def test_foo_w_function_declaration_w_aliases
    #skip 'examine this'
    blk = Visher.parse! 'function baz() { return false }'
    @vm.call blk
    @vm.fs.aliases['foo'] = qs 'baq'
    @vm.fs.aliases['baq'] = qs 'baz'
    s = parse 'foo'
    result = s.call env: @vm.ios, frames: @vm.fs
    assert_false result
  end
  def test_thing_w_f_is_false_returns_false
    @vm.fs.aliases['f'] = qs 'false'
    s = parse 'f'
    result = s.call(env: @vm.ios, frames: @vm.fs)
    assert_false result
  end
  def test_recursive_alias_calls_raise_alias_stack_too_deep
    @vm.fs.aliases['foo'] = qs 'bar'
    @vm.fs.aliases['bar'] = qs 'baz'
    @vm.fs.aliases['baz'] = qs 'echo bad juju;foo'
    s = parse 'foo'
    assert_raises AliasStackTooDeep do
      s.call(env: @vm.ios, frames: @vm.fs)
    end
  end
end
