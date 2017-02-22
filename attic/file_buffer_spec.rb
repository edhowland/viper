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
  subject do
    File.stub(:write, nil, ['dummy.txt', '']) do
      buf.ins 'hello'; buf.save; buf.dirty?
    end
  end

  specify { subject.must_equal false }
end

describe 'should_save?' do
  let(:buf) { FileBuffer.new 'spec_helper.rb' }
  subject { buf.should_save? }

  specify { subject.must_equal false }

end

describe 'should_save? should be true' do
  let(:buf) { FileBuffer.new 'xyzzy.txt' }
  subject { buf.ins 'line 1'; buf.should_save? }

  specify { subject.must_equal true }

end

describe 'ReadOnlyFileBuffer' do
  let(:buf) { ReadOnlyFileBuffer.new 'file.rb' }
  subject { buf.save }

  specify { subject }
end

describe 'existing file' do
  let(:buf) { FileBuffer.new SRC_ROOT + '/spec/spec_helper.rb' }
  subject { buf.name.pathmap('%f') }

  specify { subject.must_equal 'spec_helper.rb' }
end

describe 'restore' do
  let(:buf) { FileBuffer.new SRC_ROOT + '/spec/dummy.rb' }
  subject { buf.ins "# this is a comment\n"; buf.restore; buf.dirty? }

  specify { subject.must_equal false }
end

describe 'name=' do
  let(:buf) { FileBuffer.new 'file.rb' }
  subject { buf.fname = 'myfile.rb'; buf.fname }

  specify { subject.must_equal 'myfile.rb' }
end
