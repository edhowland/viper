# scratch_buffer_spec.rb - specs for scratch_buffer

require_relative 'spec_helper'

describe 'name: Scratch 1' do
  before { $buffer_ring.clear }

  let(:buf) { ScratchBuffer.new }
  subject { buf.name }

  specify { subject.must_equal 'Scratch 1' }
end

describe 'name : 2 -after two buffers' do
  before { $buffer_ring.clear }

  let(:buf) { ScratchBuffer.new }
  let(:buf2) { ScratchBuffer.new }
  subject { $buffer_ring << buf; buf2.name }

  specify { subject.must_equal 'Scratch 2' }
end

# specs around redo, undo at beginning/end of CommandBuffer
describe 'empty: redo' do
  let(:buf) { ScratchBuffer.new }
  subject { buf.redo }

  specify { subject }
end

describe 'empty: undo' do
  let(:buf) { ScratchBuffer.new }
  subject { buf.undo }

  specify { subject }

end

describe 'can_undo? on empty buffer is false' do
  let(:buf) { ScratchBuffer.new }

  specify { buf.can_undo?.must_equal false }
  specify { buf.can_redo?.must_equal false }
end

describe 'can undo after ins' do
  let(:buf) { ScratchBuffer.new }
  subject { buf.ins 'i'; buf.can_undo? }

  specify { subject.must_equal true }

end

describe 'can redo after ins, undo' do
  let(:buf) { ScratchBuffer.new }
  subject { buf.ins 'i'; buf.undo; buf.can_redo? }

  specify { subject.must_equal true }

end

describe 'cannot redo after ins, undo, redo' do
  let(:buf) { ScratchBuffer.new }
  subject { buf.ins 'i'; buf.undo; buf.redo; buf.can_redo? }

  specify { subject.must_equal false }

end

describe 'cannot undo after ins, undo' do
  let(:buf) { ScratchBuffer.new }
  subject { buf.ins 'i'; buf.undo; buf.can_undo? }

  specify { subject.must_equal false }

end

describe 'Readonly also cannot undo' do
  let(:buf) { ReadOnlyBuffer.new '' }
  subject { buf.ins 'xxx'; buf.can_undo? }

  specify { subject.must_equal false }
end

describe 'NonRecordable also cannot redo' do
  let(:buf) { ReadOnlyBuffer.new 'xxx' }
  subject { buf.del_at; buf.undo; buf.can_redo? }

  specify { subject.must_equal false }
end

describe 'NonRecordable cannot record' do
  let(:buf) { ReadOnlyBuffer.new 'x' }
  subject { buf.record :del }

  specify { subject }
end

describe 'NonRecordable nop for undo/redo' do
  let(:buf) { ReadOnlyBuffer.new "line\nline\nline\n" }
  subject { buf.down; buf.undo; buf.redo; buf.position }

  specify { subject.must_equal 5 }
end
