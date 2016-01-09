# multi_line_buffer_spec.rb - specs for multi_line_buffer

require_relative 'spec_helper'
describe 'insert char' do
  let(:buf) {MultiLineBuffer.new }
  subject { buf.ins 'a' }

  specify { subject; buf.line.must_equal 'a' }

end

describe 'del' do
  let(:buf) {MultiLineBuffer.new }
  subject { buf.ins 'abcd'; buf.del; buf.line }

  specify { subject.must_equal 'abc' }

end

describe 'set_mark' do
  let(:buf) {MultiLineBuffer.new }
  subject { buf.ins 'abc'; buf.set_mark; buf.mark_set? }

  specify { subject.must_equal true }

end
