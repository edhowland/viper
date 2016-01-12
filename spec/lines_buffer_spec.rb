# lines_buffer_spec.rb - specs for lines_buffer

require_relative 'spec_helper'

describe 'goto line 4' do
  let(:buf) {Buffer.new "line 1\nline 2\nline 3\nline 4" }
  subject { buf.goto 4; buf.line }

  specify { subject.must_equal 'line 4' }
end


describe 'cannot jump past end of buffer' do
  let(:buf) {Buffer.new "line 1" }
  subject { buf.goto 99; buf.line }

  specify { subject.must_equal 'line 1' }

end
