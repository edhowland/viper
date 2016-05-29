# raw_buffer_spec.rb - specs for raw_buffer

require_relative 'spec_helper'

describe RawBuffer do
  let(:buf) { RawBuffer.new 'if ' }
  subject { buf.line }
  
  specify { subject.must_equal 'if ' }
end
