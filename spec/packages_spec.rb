# packages_spec.rb - specs for packages

require_relative 'spec_helper'

describe 'package init resolves full path' do
  let(:pkg) { Viper::Package.new 'debug' }
  subject { pkg.name }

  specify { subject.must_equal 'debug' }
end
