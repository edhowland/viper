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

  describe 'when given a tab' do
    let(:buf) { RawBuffer.new "\t" }
    it 'should report tab' do
      buf.at.must_equal "tab"
    end
  end
  
  describe 'when given a backslash b' do
    let(:buf) { RawBuffer.new "\b" }
    it 'should report back tab' do
      buf.at.must_equal "back tab"
    end
  end
  
  
end

  describe 'line' do
    describe 'when given a line with backslash bs' do
      let(:buf) { RawBuffer.new "0123\b456\b789" }
      
      it 'should report 0123back tab456back tab789' do
        buf.line.must_equal "0123back tab456back tab789"
      end
    end
    
  end
  

