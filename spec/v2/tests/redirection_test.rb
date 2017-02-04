# redirection_test.rb - class RedirectionTest -  test  for testing Redirection

require_relative 'test_helper'

class ObjectRedir
  attr_reader :target, :mode
end

class RedirectionTest  < BaseSpike
  def set_up
    @target = ->(env:, frames:) { 'xxyyzz' }
    @ios = FrameStack.new
    @frames = FrameStack.new
    @frames[:ifs] = ' '
  end
  def test_init
    @redir = Redirection.new '>', @target
  end
  def test_call
        @redir = Redirection.new '>', @target
@redir.call env:@ios, frames:@frames
assert_is @ios[:out], ObjectRedir
assert_eq @ios[:out].target, 'xxyyzz'
assert_eq @ios[:out].mode, 'w'
  end
  def test_call_with_stdin
    @redir = Redirection.new '<', @target
    result = @redir.call(env:@ios, frames:@frames)
    assert_nil result
    assert_is @ios[:in], ObjectRedir
    assert_eq @ios[:in].target, 'xxyyzz'
    assert_eq @ios[:in].mode, 'r'
  end
  def test_call_with_append
    @redir = Redirection.new '>>', @target
    result = @redir.call env:@ios, frames:@frames
    assert_nil result
    assert_is @ios[:out], ObjectRedir
    assert_eq @ios[:out].target, 'xxyyzz'
    assert_eq @ios[:out].mode, 'a'
  end
  def test_deref_target
    @frames[:kk] = 'hello'
    var = Deref.new :kk
    result = var.call frames:@frames
    assert_eq result, 'hello'
  end
  def test_redir_target_is_deref
    @frames[:pathn] = 'xxyyzz'
    var = Deref.new :pathn
    redir = Redirection.new '<', var
    result = redir.call env:@ios, frames:@frames
    assert_is @ios[:in], ObjectRedir
    #assert_eq @ios[:in].target, 'xxyyzz'
    assert_eq @ios[:in].target, 'xxyyzz'

  end
end
