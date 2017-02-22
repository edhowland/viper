# cursor_movement_spec.rb - specs for cursor_movement

require_relative 'spec_helper'

describe 'up on empty buffer' do
  let(:buf) { Buffer.new '' }
  subject { buf.up }

  specify { ->() { subject }.must_raise BufferExceeded; buf.col.must_equal 0 }
end

describe 'simple single line' do
  let(:buf) { Buffer.new 'line 1' }
  subject { buf.down }

  specify { subject }
end

describe 'single line and 2 downs, exception raised' do
  let(:buf) { Buffer.new 'ine 1' }
  subject { buf.down; buf.down }

  specify { -> { subject }.must_raise BufferExceeded }
end

describe 'single line with newline' do
  let(:buf) { Buffer.new "line 1\n" }
  subject { buf.down }

  specify { subject; buf.at.must_equal nil }

end

describe '2 lines first line, empty line' do
  let(:buf) { Buffer.new "line 1\n\n" }
  subject { buf.down; buf.at }

  specify { subject.must_equal "\n"; buf.position.must_equal 7 }

end

describe '2 empty lines' do
  let(:buf) { Buffer.new "\n\n" }
  subject { buf.down; buf.position }

  specify { subject.must_equal 1 }

end

describe 'fin, top, position should be 0' do
  let(:buf) { Buffer.new "abcd\nefgh\n" }
  subject { buf.fin; buf.beg; buf.position }

  specify { subject.must_equal 0 }

end

describe '3 empty lines, 2 downs' do
  let(:buf) { Buffer.new "\n\n\n" }
  subject { buf.down; buf.down; buf.position }

  specify { subject.must_equal 2; buf.at.must_equal "\n" }

end

describe 'empty line, line, at l' do
  let(:buf) { Buffer.new "\nline 1\n" }
  subject { buf.down; buf.at }

  specify { subject.must_equal 'l' }

end

describe '3 lines, correct column' do
  let(:buf) { Buffer.new "abcd\nefgh\nijkl\n" }
  subject { buf.down; buf.down; buf.at }

  specify { subject.must_equal 'i' }

end

describe 'up empty buffer' do
  let(:buf) { Buffer.new '' }
  subject { buf.up }

  specify { -> { subject }.must_raise BufferExceeded }

end

describe 'up single line' do
  let(:buf) { Buffer.new 'line 1' }
  subject { buf.fin; buf.up; buf.at }

  specify { subject.must_equal 'l' }
end

describe 'up single line w/newline' do
  let(:buf) { Buffer.new "line 1\n" }
  subject { buf.fin; buf.up; buf.at }

  specify { subject.must_equal 'l' }

end

describe '3 empty lines' do
  let(:buf) { Buffer.new "\n\n\n" }
  subject { buf.fin; buf.up; buf.position }

  specify { subject.must_equal 2 }

end

describe 'up correct col after 2 ups' do
  let(:buf) { Buffer.new "0123\n0123\n0123\n" }
  subject { buf.fin; buf.back 3; buf.up; buf.up; buf.at }

  specify { subject.must_equal '2'; buf.position.must_equal 2 }
end

describe 'front of line' do
  let(:buf) { Buffer.new '0123abcd' }
  subject { buf.back_of_line; buf.front_of_line; buf.position }

  specify { subject.must_equal 0 }

end

describe 'front_of_line 2nd line' do
  let(:buf) { Buffer.new "0123\nabcd\n" }
  subject { buf.fwd; buf.down; buf.fwd; buf.front_of_line; buf.at }

  specify { subject.must_equal 'a' }

end
