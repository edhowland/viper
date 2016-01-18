# file_buffer_spec.rb - specs for file_buffer

require_relative 'spec_helper'

describe 'dirty?' do
  let(:buf) { Buffer.new '' }
  subject { buf.dirty? }

  specify { subject.must_equal false }
end

describe 'dirty? true after ins' do
  let(:buf) { Buffer.new '' }
  subject { buf.ins 'a'; buf.dirty? }

  specify { subject.must_equal true }
end

describe 'dirty? true after del' do
  let(:buf) { Buffer.new 'asdef' }
  subject { buf.fwd; buf.del; buf.dirty? }

  specify { subject.must_equal true }
end

describe 'dirty buffer now clean after .save' do
  let(:buf) { FileBuffer.new 'dummy.txt' }
  subject { buf.ins 'hello'; buf.save; buf.dirty? }

  specify { subject.must_equal false }
end

describe 'should_save?' do
  let(:buf) {FileBuffer.new 'spec_helper.rb' }
  subject { buf.should_save? }

  specify { subject.must_equal false }

end

describe 'should_save? should be true' do
  let(:buf) {FileBuffer.new 'xyzzy.txt' }
  subject { buf.ins 'line 1'; buf.should_save? }

  specify { subject.must_equal true }

end
