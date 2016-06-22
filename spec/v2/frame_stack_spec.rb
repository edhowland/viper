# frame_stack_spec.rb - specs for frame_stack

require_relative 'spec_helper'

describe FrameStack do
  describe 'with empty starting frame' do
    let(:fs) { FrameStack.new }
    subject { fs[:key] }
    it 'should be empty string' do
      subject.must_equal ''
    end
  end
  describe 'setting value, getting it back' do
    let(:fs) { FrameStack.new }
    before { fs[:key] = 'dog' }
    subject { fs[:key] }
    it 'should be dog' do
      subject.must_equal 'dog'
    end
  end
end
