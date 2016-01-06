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
