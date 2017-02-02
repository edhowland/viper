# buffer_test.rb - class BufferTest - tests for class Buffer
require_relative 'test_helper'

class BufferTest < BaseSpike
  def set_up
    @buffer = Buffer.new ''
  end

  def test_config_ok
    assert_is @buffer, Buffer
  end
  
  def test_buffer_resolves_to_itself
    @buffer = Buffer.new 'abcd'
    assert_equals @buffer.to_s, 'abcd'
  end
  def test_insert
    @buffer.ins 'the quick brown fox'
    assert_equals @buffer.to_s, 'the quick brown fox'
  end
  def test_del_raises_exception
    assert_raises RuntimeError do 
      @buffer.del
    end
  end
  def test_fwd
    @buffer = Buffer.new '01234'
    @buffer.fwd
    assert_equals @buffer.at, '1'
  end
  def test_fwd_then_del
    @buffer = Buffer.new '012345'
    @buffer.fwd
    @buffer.del
    assert_equals @buffer.to_s, '12345'
  end
  def test_fwd_then_ins
    @buffer = Buffer.new 'the brown fox'
    @buffer.fwd; @buffer.fwd; @buffer.fwd; @buffer.fwd
    @buffer.ins 'quick '
    assert_eq @buffer.to_s, 'the quick brown fox'
  end
  def test_fwd_back_ins
    @buffer = Buffer.new '012345'
    @buffer.fwd; @buffer.fwd;@buffer.fwd
    assert_eq @buffer.at, '3'
    @buffer.back
    @buffer.ins 'A'
    assert_eq @buffer.to_s, '01A2345'
  end
  def test_srch_fwd
    @buffer = Buffer.new 'Now is the time for all good men to come to the aid of their country'
    @buffer.srch_fwd 'good'
    assert_eq @buffer.at, 'g'
  end
  def test_srch_fwd_non_existant
        @buffer = Buffer.new 'Now is the time for all good men to come to the aid of their country'
        @buffer.srch_fwd 'zzzyyxx'
        assert_eq @buffer.at, 'N'

  end
end
