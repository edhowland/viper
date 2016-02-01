# non_writable_spec.rb - specs for non_writable

require_relative 'spec_helper'

class CannotWriteMe < Buffer
  include NonWritable
end

describe 'NonWritable' do
  let(:buf) { CannotWriteMe.new '' }
  subject { buf.ins 'xxx'; buf.dirty? }

  specify { subject.must_equal false }
end

describe 'NonWritable cannot delete' do
  let(:buf) { CannotWriteMe.new 'xxx' }
  subject { buf.del; buf.dirty? }

  specify { subject.must_equal false }
end

describe 'name shows read only' do
  let(:buf) { CannotWriteMe.new '' }
  subject { buf.name = 'hide'; buf.name }

  specify { subject.must_equal 'hide (read only)' }
end
