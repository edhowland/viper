# make_bindings_spec.rb - specs for make_bindings

require_relative 'spec_helper'

describe 'make_bindings returns a key inserter proc for letters' do
  let(:buf) { Buffer.new '' }
  let(:bind) { make_bindings }
  let(:prc) { bind[:key_p] }
  subject { prc.call(buf); buf.to_s }

  specify { subject.must_equal 'p' }
end

describe 'inserter for caps' do
  let(:buf) { Buffer.new '' }
  let(:bind) { make_bindings }
  let(:prc) { bind[:key_A] }
  subject { prc.call(buf); buf.to_s }

  specify { subject.must_equal 'A' }
end

describe 'inserter 0' do
  let(:buf) { Buffer.new '' }
  let(:bind) { make_bindings }
  let(:prc) { bind[:key_0] }
  subject { prc.call(buf); buf.to_s }

  specify { subject.must_equal '0' }
end

describe 'special chars :space' do
  let(:buf) { Buffer.new '' }
  let(:bind) { make_bindings }
  let(:prc) { bind[:space] }
  subject { prc.call(buf); buf.to_s }

  specify { subject.must_equal ' ' }
end

describe 'ctrl_z cannot undo' do
  let(:buf) { ReadOnlyBuffer.new 'yyy' }
  let(:bind) { make_bindings }
  let(:prc) { bind[:ctrl_z] }
  subject { buf.ins 'xxx'; prc.call(buf); buf.to_s }

  specify { subject.must_equal 'yyy' }
end

describe 'Can undo insert' do
  let(:buf) { ScratchBuffer.new }
  let(:bind) { make_bindings }
  let(:prc) { bind[:ctrl_z] }
  subject { buf.ins 'xxx'; prc.call(buf); buf.to_s }

  specify { subject.must_equal '' }
end

class CannotRecordMe < Buffer
  include NonRecordable
end

describe 'ReadOnlyBuffer cannot redo from ctrl_u' do
  let(:buf) { CannotRecordMe.new '' }
  let(:bind) { make_bindings }
  let(:prc) { bind[:ctrl_u] }
  subject { buf.ins 'xxx'; buf.undo; prc.call(buf); buf.to_s }

  specify { subject.must_equal 'xxx' }
end

describe 'Can redo undon action from proc in bindings' do
  let(:buf) { ScratchBuffer.new }
  let(:bind) { make_bindings }
  let(:prc) { bind[:ctrl_u] }
  subject { buf.ins 'xxx'; buf.undo; prc.call(buf); buf.to_s }

  specify { subject.must_equal 'xxx' }
end

describe 'backspace if mark set' do
  let(:buf) { ScratchBuffer.new }
  let(:bind) { make_bindings }
  let(:prc) { bind[:backspace] }
  subject { buf.ins 'xxxxx'; buf.beg; buf.set_mark; buf.fwd 3; prc.call(buf); $clipboard }

  specify { subject.must_equal 'xxx' }
end

describe 'backspace when no mark set' do
  let(:buf) { ScratchBuffer.new }
  let(:bind) { make_bindings }
  let(:prc) { bind[:backspace] }
  subject { buf.ins 'xyz'; prc.call(buf); buf.to_s }

  specify { subject.must_equal 'xy' }
end

describe 'fn_4 sets mark when not set' do
  let(:buf) { ScratchBuffer.new }
  let(:bind) { make_bindings }
  let(:prc) { bind[:fn_4] }
  subject { buf.ins 'zzz'; buf.beg; prc.call(buf); buf.mark_set? }

  specify { subject.must_equal true }
end

describe 'fn_4 unsets mark when set' do
  let(:buf) { ScratchBuffer.new }
  let(:bind) { make_bindings }
  let(:prc) { bind[:fn_4] }
  subject { buf.ins 'zzz'; buf.beg; buf.set_mark; buf.fwd; prc.call(buf); buf.mark_set? }

  specify { subject.must_equal false }
end
