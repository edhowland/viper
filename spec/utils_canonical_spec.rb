# util_canonical_spec.rb - specs for util_canonical

require_relative 'spec_helper'

describe 'cannocial viper_abba' do
  subject { canonical 'viper_abba' }

  specify { subject.must_equal 'ViperAbba' }
end
