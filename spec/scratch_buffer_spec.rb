

require_relative 'spec_helper'

describe 'name: Scratch 1' do
  let(:buf) {ScratchBuffer.new  }
  subject { buf.name }

  specify { subject.must_equal 'Scratch 1' }

end


describe 'name : 2 -after two buffers' do
  let(:buf) {ScratchBuffer.new }
  let(:buf2) {ScratchBuffer.new }
  subject {$buffer_ring << buf;  buf2.name }

  specify { subject.must_equal 'Scratch 2' }
end
