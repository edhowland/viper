# find_spec.rb - specs for find

require_relative 'spec_helper'

describe 'find pattern' do
  let(:buf) { Buffer.new 'hello world' }
  subject { find(buf, /world/); buf.position }

  specify { subject.must_equal 6 }
end

describe 'rev_find' do
  let(:buf) { Buffer.new 'hello world' }
  subject { buf.fin; rev_find buf, /hello/; buf.position }

  specify { subject.must_equal 0 }
end


describe 'find returns false if not found' do
  let(:buf) { Buffer.new 'hello world' }
  subject { find(buf, 'good') }

  specify { subject.must_equal false }
end

describe 'find returns true if found' do
  let(:buf) { Buffer.new 'hello world' }
  subject { find buf, 'world' }

  specify { subject.must_equal true }
end

describe 'rev_find returns false if not found' do
  let(:buf) { Buffer.new 'hello world' }
  subject { buf.fin; rev_find buf, '0123' }

  specify { subject.must_equal false }
end

describe 'rev_find returns true if fount' do
  let(:buf) { Buffer.new 'hello world' }
  subject { buf.fin; rev_find buf, 'ello' }

  specify { subject.must_equal true }
end
