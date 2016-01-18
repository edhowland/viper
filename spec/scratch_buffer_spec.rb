

require_relative 'spec_helper'

describe 'name: Scratch 1' do
  before { $buffer_ring.clear }

  let(:buf) {ScratchBuffer.new  }
  subject { buf.name }

  specify { subject.must_equal 'Scratch 1' }

end


describe 'name : 2 -after two buffers' do
  before { $buffer_ring.clear }

  let(:buf) {ScratchBuffer.new }
  let(:buf2) {ScratchBuffer.new }
  subject {$buffer_ring << buf;  buf2.name }

  specify { subject.must_equal 'Scratch 2' }
end

# specs around redo, undo at beginning/end of CommandBuffer
describe 'empty: redo' do
  let(:buf) {ScratchBuffer.new }
  subject { buf.redo }

  specify { subject }
end

describe 'empty: undo' do
  let(:buf) {ScratchBuffer.new }
  subject { buf.undo }

  specify { subject }

end

describe 'can_undo? on empty buffer is false' do
  let(:buf) {ScratchBuffer.new }

  specify { buf.can_undo?.must_equal false }
  specify { buf.can_redo?.must_equal false }


end

describe 'can undo after ins' do
  let(:buf) {ScratchBuffer.new }
  subject { buf.ins 'i'; buf.can_undo? }

  specify { subject.must_equal true }

end

describe 'can redo after ins, undo' do
  let(:buf) {ScratchBuffer.new }
  subject { buf.ins 'i'; buf.undo; buf.can_redo? }

  specify { subject.must_equal true }

end

describe 'cannot redo after ins, undo, redo' do
  let(:buf) {ScratchBuffer.new }
  subject { buf.ins 'i'; buf.undo; buf.redo; buf.can_redo? }

  specify { subject.must_equal false }

end

describe 'cannot undo after ins, undo' do
  let(:buf) {ScratchBuffer.new }
  subject { buf.ins 'i'; buf.undo; buf.can_undo? }

  specify { subject.must_equal false }

end
