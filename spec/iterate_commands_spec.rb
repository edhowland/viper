# iterate_commands_spec.rb - specs for iterate_commands

require_relative 'spec_helper'

describe 'iterate_commands raises exception' do
  subject { iterate_commands [] }

  specify { -> { subject }.must_raise CommandBlockExpected }
end

describe 'iterate_commands no exception raised with block' do
  let(:buf) { Buffer.new '' }
  subject { iterate_commands([]) { buf } }

  specify { subject }
end

describe 'iterate_commands name a buffer' do
  let(:buf) { Buffer.new '' }
  let(:sexps) { parse!("name 'foo bar'") }
  subject { iterate_commands(sexps) { buf } }

  specify { subject; buf.name.must_equal 'foo bar' }
end
