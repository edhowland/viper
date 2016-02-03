# readline_spec.rb - specs for readline

require_relative 'spec_helper'

describe 'Readline.new' do
  let(:buf) { Viper::Readline.new }
  subject { buf }
  specify { subject }
end

describe 'readline' do
  let(:buf) { Viper::Readline.new }
  before { $stdin = StringIO.new "line\r" } # use \r instead \n to simulate CR in stream
  subject { buf.readline }

  specify { subject.must_equal 'line' }
end

describe 'Unbound key Fn 5' do
  let(:buf) { Viper::Readline.new }
  before { i = key_mappings.invert; $stdin = StringIO.new i[:fn_5] }
  subject { buf.readline }

  specify { subject }
end

describe 'exercise key up' do
  let(:buf) { Viper::Readline.new }
  before { i = key_mappings.invert; $stdin = StringIO.new "#{i[:up]}\r" }
  subject { buf.readline }

  # subject.must_equal ''
  specify { subject }
end

describe 'confirm default' do
  before { $stdin = StringIO.new "\r" }
  subject { confirm? 'Are you sure?', 'N' }

  specify { subject.must_equal false }
end

describe 'confirm? Y returns true' do
  before { $stdin = StringIO.new "Y\r" }
  subject { confirm? 'Are you sure?' }

  specify { subject.must_equal true }
end
