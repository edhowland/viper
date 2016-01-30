# viper_init_spec.rb - specs for viper_init

require_relative 'spec_helper'

describe 'load_rc' do
  subject { load_rc }

  specify { subject }
end


describe 'with block raising exception' do
  subject do
    load_rc do |l|
      raise RuntimeError.new "Expected Exception"
    end
  end

  specify { subject }
end
