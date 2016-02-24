# ifind_spec.rb - specs for ifind

require_relative 'spec_helper'

describe 'ifind' do
  let(:buf) { Buffer.new 'hello world' }
  before { $stdin = StringIO.new "wor" + "\r" }
  subject { ifind buf }

  specify { subject.must_equal true; buf.position.must_equal 6 }
end

describe 'irev_find' do
  let(:buf) { Buffer.new 'hello world' }
  before { $stdin = StringIO.new 'llo' + "\r"; buf.fin }
  subject { irev_find buf }

  specify { subject.must_equal true; buf.position.must_equal 2 }
end
