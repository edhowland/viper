# session_spec.rb - specs for session

require_relative 'spec_helper'

describe 'Viper::Session[]=' do
    before { Viper::Session[:key] = 'value' }
  subject { Viper::Session[:key] }

  specify { subject.must_equal 'value' }
end

describe 'clear' do
    before { Viper::Session[:key] = 'value' }
  subject { Viper::Session.clear; Viper::Session[:key] }

  specify { subject.must_be_nil }
end
