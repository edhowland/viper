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

describe 'again' do
  let(:buf) { Buffer.new "line 1\nline 2\nline 3\n" }
  before { find buf, 'line' }
  subject { again buf }

  specify { subject; buf.position.must_equal 7 }
end

describe 'command find' do
  let(:buf) { Buffer.new 'hello world' }
  let(:bind) { command_bindings }
  subject { prc = bind[:find]; prc.call(buf, 'wor'); buf.at }

  specify { subject.must_equal 'w' }
end

describe 'rev_find' do
  let(:buf) { Buffer.new 'hello world' }
  let(:bind) { command_bindings }
  before { buf.fin }
  subject { prc = bind[:rev_find]; prc.call(buf, 'hel'); buf.position }

  specify { subject.must_equal 0 }
end

describe 'command again' do
  let(:buf) { Buffer.new "line 1\nline2\nline 3\n" }
  let(:bind) { command_bindings }
  before { buf.fwd; find buf, 'line' }
  subject { prc = bind[:again]; prc.call buf; buf.line }

  specify { subject.must_equal "line 3\n" }
end
