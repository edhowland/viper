# cursor_movement_spec.rb - specs for cursor_movement

require_relative 'spec_helper'

describe 'up on empty buffer' do
  let(:buf) { Buffer.new '' }
  subject { buf.up }

  specify { ->() { subject}.must_raise BufferExceeded; buf.col.must_equal 0}
end


describe 'simple single line' do
  let(:buf) { Buffer.new 'line 1' }
  subject {  buf.down }

  specify {  ->{ subject }.must_raise BufferExceeded }

end

describe 'single line with newline' do
  let(:buf) { Buffer.new "line 1\n" }
  subject {  buf.down }

  specify { subject; buf.at.must_equal nil }

end

describe '2 lines first line, empty line' do
  let(:buf) { Buffer.new "line 1\n\n" }
  subject {  buf.down; buf.at }

  specify {  subject.must_equal "\n" }

end
