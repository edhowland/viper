# repl_spec.rb - specs for repl

require_relative 'spec_helper'

describe 'non-existant command raises CommandNotFound' do
  subject {  exec_cmd(:xyzzy, nil) }

  specify {  -> { subject }.must_raise CommandNotFound }
end

describe 'will execute command if it exists passing 1 arg' do
  before { $commands[:babel] = ->(b, *args) { args[0] } }
  subject { exec_cmd :babel, nil, 'ABCD' }

  specify { subject.must_equal 'ABCD' }
end
