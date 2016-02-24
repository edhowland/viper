# replace_spec.rb - specs for replace

require_relative 'spec_helper'

describe 'replace' do
  let(:buf) { Buffer.new 'hello world' }
  subject { replace buf, 'world', 'cosmos' }

  specify { subject; buf.to_s.must_equal 'hello cosmos' }
end

describe 'replace fails to find pattern first' do
  let(:buf) { Buffer.new 'hello world' }
  subject { replace buf, 'cosmos', 'world' }

  specify { subject.must_equal false; buf.to_s.must_equal 'hello world' }
end
