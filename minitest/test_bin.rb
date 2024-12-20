# test_bin.rb - tests for bin/* commands

require_relative 'test_helper'

class BinTests < MiniTest::Test
  def setup
    @orig_dir = File.dirname(File.expand_path(__FILE__))
    @errbuf = StringIO.new
    @outbuf = StringIO.new
    @inbuf = StringIO.new
    @vm = VirtualMachine.new
    @vm.ios[:err] = @errbuf
    @vm.ios[:out] = @outbuf
    @vm.cd @orig_dir, env:@vm.ios, frames:@vm.fs

    @vm.mount '/v', env:@vm.ios, frames:@vm.fs
    @vm.mkdir '/v/bin', env:@vm.ios, frames:@vm.fs
    @vm.install env:@vm.ios, frames:@vm.fs
  end
  def go command
    @vm.call(Visher.parse!(command))
  end
  def test_stat_examine_reports_directory
    cmd = Stat.new
    str = cmd.examine Hal, :directory?, '/v/bin'
    assert_equal str, 'directory? true'
  end
  def test_stat_examine_directory_false
        cmd = Stat.new
    str = cmd.examine Hal, :directory?, '/v/xxx'
    assert_equal str, 'directory? false'
  end
  def test_examine_virtual_dir
    cmd = Stat.new
    str = cmd.examine Hal, :virtual?, '/v/bin'
    assert_equal str, 'virtual? true'
  end
  def test_examine_virtual_false
    cmd = Stat.new
    str = cmd.examine Hal, :virtual?, '/dev/null'
    assert_equal str, 'virtual? false'
  end
  # ls tests
  def test_ls_dir_star_w_directory
    cmd = Ls.new
    assert_equal cmd.dir_star('/v/bin'), '/v/bin/*'
  end
  def test_dir_star_w_file
    cmd = Ls.new
    assert_equal cmd.dir_star('xx'), 'xx'
  end
  def test_capture_one_block
    cmd = Capture.new
    result = cmd.call env: @vm.ios, frames: @vm.fs
    assert_false result
  end
  def test_capture_works_w_one_lambda
    cmd = Capture.new
    block = Block.new [ True.new ]
    result = cmd.call block, env: @vm.ios, frames: @vm.fs
    assert result
  end
  def test_capture_w_2_blocks
    cmd = Capture.new
        block = Block.new [ True.new ]
        handler = Block.new [ ]
    result = cmd.call block, handler, env: @vm.ios, frames: @vm.fs
    assert result
  end
  def test_capture_w_3_blocks
        cmd = Capture.new
        block = Block.new [ True.new ]
        handler = Block.new [ ]
           fin = Block.new [ False.new ]
    result = cmd.call block, handler, fin, env: @vm.ios, frames: @vm.fs
    assert result
  end
  def test_capture_w_exception
    cmd = Capture.new
    block = Block.new [ Raise.new ]
    handler = Visher.parse! 'result=ok; global result'
    result = cmd.call block, handler, env: @vm.ios, frames: @vm.fs
    assert_false result
    assert_equal @vm.fs[:result], 'ok'
  end
  def test_capture_sets_last_exception
    go 'capture { raise bad }'
    assert_equal @vm.fs[:last_exception], 'bad'
  end
  def test_capture_catch_block_runs
    go 'capture { raise bad } { xx=hi; global xx }'
    assert_equal @vm.fs[:xx], 'hi'
  end
  def test_capture_ensure_always_runs_w_no_raise
    go 'capture { nop } { nop } { xx=hi; global xx }'
        assert_equal @vm.fs[:xx], 'hi'
  end
  def test_capture_ensure_runs_with_raise
    go 'capture { raise bad } { nop } { xx=hi; global xx }'
        assert_equal @vm.fs[:xx], 'hi'
  end
  def test_capture_w_raises_and_redirection_still_has_original_stream
    go 'function db() { raise bad; echo ok }; capture { db >> /v/xxx } { echo caught exception :last_exception } { echo finally }'
  end
  def test_stat_ok
    go 'stat /v/bin'
    assert_equal @outbuf.string, "stat\n/v/bin\nvirtual? true\ndirectory? true\nVFSNode: directory node: bin\n"
  end
  def betx(inp, mtch)
    btw = Between.new
    @inbuf = StringIO.new inp
    @vm.ios[:in] = @inbuf
    btw.call mtch, env:@vm.ios, frames:@vm.fs
    @vm.ios[:out].string
  end
  def test_between_w_no_fence_posts
    btw = Between.new
    expected = "line1\nline2\nline3\n"
    @inbuf = StringIO.new expected
    @vm.ios[:in] = @inbuf
    btw.call 'fn_6', env:@vm.ios, frames:@vm.fs
    assert_equal @vm.ios[:out].string, expected
  end
  def test_between_w_single_fence_post
    @inbuf = StringIO.new "key_d\nfn_6\nkey_e\nkey_f\n"
    @vm.ios[:in] = @inbuf
    btw = Between.new
    btw.call 'fn_6', env:@vm.ios, frames:@vm.fs
    assert_equal @vm.ios[:out].string, "key_e\nkey_f\n"
  end
  def test_between_gets_every_thing_between_2_fence_posts
    @inbuf = StringIO.new "key_h\nfn_6\nkey_e\nkey_l\nkey_l\nfn_6\nkey_o\n"
    btw = Between.new
    @vm.ios[:in] = @inbuf
    btw.call 'fn_6', env:@vm.ios, frames:@vm.fs
    assert_equal @vm.ios[:out].string, "key_e\nkey_l\nkey_l\n"
  end

  def test_between_just_one_fence_post
    actual = betx("fn_6\n", 'fn_6')
    assert_equal actual, ''
  end
end
