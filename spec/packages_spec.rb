# packages_spec.rb - specs for packages

require_relative 'spec_helper'

def home_path(path)
  File.expand_path('~').pathmap("%p/#{path}")
end

def home_pkg_path(pkg, fname)
  home_path ".viper/packages/#{pkg}/#{fname}"
end

describe 'package init resolves name' do
  let(:pkg) { Viper::Package.new 'viper_debug' }
  before { Viper::Packages.store.clear }
  subject { pkg.name }

  specify { subject.must_equal 'viper_debug' }
end

describe 'package init resolves full path from Viper::Packages::PATH_NAME' do
  let(:pkg) { Viper::Package.new 'viper_debug' }
  before { Viper::Packages.store.clear }
  subject { pkg.path }

  specify { subject.must_equal home_path('.viper/packages/viper_debug/') }
end

describe 'Viper::Packages::PACKAGE_PATH includes our home base' do
  subject { Viper::Packages::PACKAGE_PATH }

  specify { subject.must_equal [home_path('.viper/packages/')] }
end

describe 'load_viper_path debug' do
  let(:pkg) { Viper::Package.new 'viper_debug' }
  before { Viper::Packages.store.clear }
  subject { pkg.viper_path 'load' }

  specify { subject.must_equal home_pkg_path('viper_debug', 'load.viper') }
end

describe 'load' do
  let(:pkg) { Viper::Package.new 'viper_debug' }
  before { Viper::Packages.store.clear }

  subject { pkg.load }

  specify { subject }
end

describe 'lib_path' do
  let(:pkg) { Viper::Package.new 'viper_debug' }
  before { Viper::Packages.store.clear }

  subject { pkg.lib_path }

  specify { subject.must_equal home_pkg_path('viper_debug', 'lib/') }
end

describe 'version_const_string' do
  let(:pkg) { Viper::Package.new 'viper_ruby' }
  before { Viper::Packages.store.clear }

  subject { pkg.const_string }

  specify { subject.must_equal 'Viper::Packages::ViperRuby' }
end

describe 'version' do
  let(:pkg) { Viper::Package.new 'viper_ruby' }
  before {Viper::Packages.store.clear;  pkg.load }
  subject { pkg.version }

  specify { subject.wont_be_nil }
  specify { subject.wont_be_empty }
end

describe 'package_info' do
  subject { package_info 'xyzzy' }

  specify { ->{ subject }.must_raise Viper::Packages::PackageNotFound  }
end

describe 'package_info viper_debug' do
  let(:pkg) { Viper::Package.new 'viper_debug' }
  before { Viper::Packages.store.clear; pkg.load  }
  subject { package_info 'viper_debug' }

  specify {  subject.must_equal 'Package name: viper_debug version: 0.1.0' }
  specify { Viper::Packages.store.length.must_equal 1 }
end

describe 'Viper::Packages[0]' do
    let(:pkg) { Viper::Package.new 'viper_debug' }
  before { Viper::Packages.store.clear; pkg }
  subject { Viper::Packages[0] }

  specify { subject.must_be_instance_of Viper::Package }

end

describe 'Viper::Packages[0]=' do
  let(:pkg) { Viper::Package.new 'viper_debug' }
  before { Viper::Packages.store.clear; pkg }
  subject { Viper::Packages[1] = pkg }

  specify { subject }
end
