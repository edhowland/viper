# mark_buffer_spec.rb - specs for mark_buffer

require_relative 'spec_helper'

describe 'mark initially unset' do
  let(:buf) { Buffer.new 'good times' }
  subject {  buf.mark_set? }

  specify {  subject.must_equal false }

end

describe 'set mark' do
  let(:buf) { Buffer.new 'good times' }
  subject {  buf.set_mark; buf.mark_set? }

  specify {  subject.must_equal true }

end

describe 'unset mark' do
  let(:buf) { Buffer.new 'good times' }
  subject {  buf.set_mark; buf.unset_mark; buf.mark_set? }

  specify {  subject.must_equal false }

end

describe 'set_if_not_set' do
  let(:buf) {Buffer.new '0123abcd' }
  subject {buf.set_if_not_set; buf.mark_set?  }

  specify {  subject.must_equal true }
end

describe 'set_if_not_set after set_mark' do
  let(:buf) {Buffer.new 'abcd' }
  subject {  buf.set_mark; buf.set_if_not_set; buf.mark_set? }

  specify {  subject.must_equal true }

end

describe 'set_if_not_set after unset_mark' do
  let(:buf) {Buffer.new '0123' }
  subject { buf.unset_mark; buf.set_if_not_set; buf.mark_set? }
  specify { subject.must_equal true }
end
