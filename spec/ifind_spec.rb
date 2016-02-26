# ifind_spec.rb - specs for ifind

require_relative 'spec_helper'

describe 'ifind' do
  let(:buf) { Buffer.new 'hello world' }
  before { $stdin = StringIO.new 'wor' + "\r" }
  subject { ifind buf }

  specify { subject.must_equal true; buf.position.must_equal 6 }
end

describe 'irev_find' do
  let(:buf) { Buffer.new 'hello world' }
  before { $stdin = StringIO.new 'llo' + "\r"; buf.fin }
  subject { irev_find buf }

  specify { subject.must_equal true; buf.position.must_equal 2 }
end

describe 'ifind - rings bell if at end of search line buffer' do
  let(:buf) { SearchLineBuffer.new }
  before { $stdin = StringIO.new "\e[B" + "\r" }
  subject { buf.readline }

  specify { subject }
end

describe 'command ifind' do
  let(:buf) { Buffer.new 'hello world' }
  let(:bind) { command_bindings }
  before { $stdin = StringIO.new "wor\r" }
  subject { prc = bind[:ifind]; prc.call buf; buf.at }

  specify { subject.must_equal 'w' }
end

describe 'irev_find' do
  let(:buf) { Buffer.new 'hello world' }
  let(:bind) { command_bindings }
  before { $stdin = StringIO.new "hell\r"; buf.fin }
  subject { prc = bind[:irev_find]; prc.call buf; buf.position }

  specify { subject.must_equal 0 }
end
