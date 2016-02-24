# chord_spec.rb - specs for chord

require_relative 'spec_helper'

describe 'play_chord :key_d' do
  let(:buf) { Buffer.new "line 1\nline 2\nline 3\n" }
  before { $stdin = StringIO.new('d'); buf.down }
  subject { play_chord buf, :meta_d }

  specify { subject; buf.line.must_equal "line 3\n" }
end

describe 'play_chord meta_d, shift_home' do
  let(:buf) { Buffer.new 'hello world' }
  before { $stdin = StringIO.new "\e[H"; buf.fwd 6 }
  subject { play_chord buf, :meta_d }

  specify { subject; buf.line.must_equal 'world' }
end

describe 'play_chord meta_d, shift_end' do
  let(:buf) { Buffer.new 'hello world' }
  before { $stdin = StringIO.new "\e[F"; buf.fwd 5 }
  subject { play_chord buf, :meta_d }

  specify { subject; buf.line.must_equal 'hello' }
end

describe 'play_chord meta_d, shift_pgup' do
  let(:buf) { Buffer.new '0123456789' }
  before { $stdin = StringIO.new"\e[5~"; buf.fin; buf.back  }
  subject { play_chord buf, :meta_d }

  specify { subject; buf.line.must_equal '9' }
end

describe 'play_chord :meta_d, :shift_pgdn' do
  let(:buf) { Buffer.new '0123456789' }
  before { $stdin = StringIO.new "\e[6~"; buf.fwd }
  subject { play_chord buf, :meta_d }

  specify { subject; buf.line.must_equal '0' }
end
