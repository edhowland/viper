# multi_line_buffer_spec.rb - specs for multi_line_buffer

require_relative 'spec_helper'
describe 'insert char' do
  let(:buf) { MultiLineBuffer.new }
  subject { buf.ins 'a' }

  specify { subject; buf.line.must_equal 'a' }
end

describe 'del' do
  let(:buf) { MultiLineBuffer.new }
  subject { buf.ins 'abcd'; buf.del; buf.line }

  specify { subject.must_equal 'abc' }
end

describe 'set_mark' do
  let(:buf) { MultiLineBuffer.new }
  subject { buf.ins 'abc'; buf.set_mark; buf.mark_set? }

  specify { subject.must_equal true }
end

describe 'head' do
  let(:buf) { MultiLineBuffer.new }
  subject { buf.ins 'line'; buf.front_of_line; buf.at }

  specify { subject.must_equal 'l' }
end

describe 'fwd 2' do
  let(:buf) { MultiLineBuffer.new }
  subject { buf.ins 'line'; buf.front_of_line; buf.fwd 2; buf.at }

  specify { subject.must_equal 'n' }
end

describe 'back 2' do
  let(:buf) { MultiLineBuffer.new }
  subject { buf.ins 'line'; buf.back_of_line; buf.back 2; buf.at }


  specify { subject.must_equal 'n' }
end

describe 'up' do
  let(:buf) { MultiLineBuffer.new }
  subject { buf.ins 'line 1'; buf.new_line; buf.ins 'line 2'; buf.up; buf.line }

  specify { subject.must_equal 'line 1' }
end

describe 'down' do
  let(:buf) { MultiLineBuffer.new }
  subject { buf.ins 'line 1'; buf.new_line; buf.ins 'line 2'; buf.up; buf.down; buf.line }

  specify { subject.must_equal 'line 2' }
end

describe 'copy' do
  let(:buf) { MultiLineBuffer.new }
  subject { buf.ins 'some word'; buf.front_of_line;  buf.fwd 5; buf.set_if_not_set; buf.back_of_line; buf.copy }

  specify { subject.must_equal 'word' }
end


describe 'cut' do
  let(:buf) { MultiLineBuffer.new }
  subject { buf.ins 'some word'; buf.front_of_line;  buf.fwd 5; buf.set_if_not_set; buf.back_of_line; buf.cut }

  specify { subject.must_equal 'word'; buf.line.must_equal 'some ' }
end

describe 'to_a' do
  let(:buf) { MultiLineBuffer.new }
  subject { buf.ins 'line'; buf.to_a }

  specify { subject.wont_be_empty }
end

describe 'beg' do
  let(:buf) { MultiLineBuffer.new }
  subject { buf.ins 'line 1'; buf.new_line; buf.ins 'line 2'; buf.new_line; buf.ins 'line 3'; buf.beg; buf.line }

  specify { subject.must_equal 'line 1' }
end


describe 'fin' do
  let(:buf) { MultiLineBuffer.new }
  subject { buf.ins 'line 1'; buf.new_line; buf.ins 'line 2'; buf.new_line; buf.ins 'line 3'; buf.beg; buf.fin; buf.line }

  specify { subject.must_equal 'line 3' }
end
