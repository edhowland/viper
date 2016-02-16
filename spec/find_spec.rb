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
