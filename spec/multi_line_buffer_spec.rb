# multi_line_buffer_spec.rb - specs for multi_line_buffer

require_relative 'spec_helper'
describe 'insert char' do
  let(:buf) {MultiLineBuffer.new }
  subject { buf.ins 'a' }

  specify { subject; buf.line.must_equal 'a' }

end
