

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
