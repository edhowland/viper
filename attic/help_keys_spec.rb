# help_keys_spec.rb - specs for help_keys

require_relative 'spec_helper'

describe 'captures unhandled exception' do
  before { $stdin = StringIO.new "\e[3~" }
  subject { help_keys }

  specify { subject }
end
