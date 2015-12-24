# lines_string_buffer_spec.rb - specs for lines_string_buffer

require_relative 'spec_helper'

describe 'empty string' do
  let(:buf) { StringBuffer.new '' }
  subject { buf.lines }

  specify { subject.length.must_equal 0 }
end
