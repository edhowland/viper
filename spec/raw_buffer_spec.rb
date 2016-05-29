# raw_buffer_spec.rb - specs for raw_buffer

require_relative 'spec_helper'

describe RawBuffer do
  let(:buf) { RawBuffer.new 'if ' }
  subject { buf }
  
  specify { subject.line.must_equal 'if ' }

  it 'should leave char unchanged' do
    subject.at.must_equal 'i'
  end

  describe 'when seeing a return' do
    let(:buf) { RawBuffer.new "\r" }
    
    it 'should say return' do
      buf.at.must_equal 'return'
    end
  end
  
end

