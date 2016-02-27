# packages_spec.rb - specs for packages

require_relative 'spec_helper'

def home_path path
  File.expand_path("~").pathmap("%p/#{path}")
end


describe 'package init resolves name' do
  let(:pkg) { Viper::Package.new 'debug' }
  subject { pkg.name }

  specify { subject.must_equal 'debug' }
end

describe 'package init resolves full path from Viper::Packages::PATH_NAME' do
  let(:pkg) { Viper::Package.new 'debug' }
  subject { pkg.path }

  specify { subject.must_equal home_path('.viper/packages/debug/') }
end

describe 'Viper::Packages::PACKAGE_PATH includes our home base' do
  subject { Viper::Packages::PACKAGE_PATH }

  specify { subject.must_equal [home_path('.viper/packages/')] }
end
