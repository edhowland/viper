# repl_spec.rb - specs for repl

require_relative 'spec_helper'

describe 'non-existant command raises CommandNotFound' do
  subject {  exec_cmd(:xyzzy, nil) }

  specify {  -> { subject }.must_raise CommandNotFound }
end
