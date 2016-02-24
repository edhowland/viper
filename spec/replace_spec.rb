# replace_spec.rb - specs for replace

require_relative 'spec_helper'

describe 'replace' do
  let(:buf) { Buffer.new 'hello world' }
  subject { replace buf, 'world', 'cosmos' }

  specify { subject; buf.to_s.must_equal 'hello cosmos' }
end
