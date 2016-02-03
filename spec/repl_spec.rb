# repl_spec.rb - specs for repl

require_relative 'spec_helper'

describe 'non-existant command raises CommandNotFound' do
  subject {  exec_cmd(:xyzzy, nil) }

  specify {  -> { subject }.must_raise CommandNotFound }
end

describe 'will execute command if it exists passing 1 arg' do
  before { $commands[:babel] = ->(_b, *args) { args[0] } }
  subject { exec_cmd :babel, nil, 'ABCD' }

  specify { subject.must_equal 'ABCD' }
end

describe 'parse_execute babel fish' do
  before { $commands[:babel] = ->(_b, *args) { args[0] } }
  subject { parse_execute nil, 'babel fish' }

  specify { subject.must_equal 'fish' }
end

describe 'parse_execute command (only)' do
  before { $commands[:babel] = ->(_b, *_args) { 'ok' } }
  subject { parse_execute nil, 'babel' }

  specify { subject.must_equal 'ok' }
end

describe 'parse_execute empty string' do
  let(:buf) { Buffer.new '' }
  subject { parse_execute buf, '' }

  specify { subject }
end

describe 'preprocess_command' do
  subject { preprocess_command '' }

  specify { subject.must_equal 'ignore' }
end
