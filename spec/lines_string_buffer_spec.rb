# lines_string_buffer_spec.rb - specs for lines_string_buffer

require_relative 'spec_helper'

describe 'empty string' do
  let(:buf) { StringBuffer.new '' }
  subject { buf.lines }

  specify { subject.length.must_equal 0 }
end

describe 'rcount_nl' do
  let(:buf) { StringBuffer.new "line 1\nline 2" }
  subject { buf.rcount_nl }

  specify { subject.must_equal 7 }
end
describe 'rcount_nl with single line' do
  let(:buf) { StringBuffer.new 'line 1' }
  subject { buf.rcount_nl }

  specify { subject.must_equal 6 }
end
