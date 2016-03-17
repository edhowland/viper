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
  subject do
    File.stub(:exist?, true) do
      pkg.name 
    end
  end

  specify { subject.must_equal 'viper_debug' }
end

describe 'package init resolves full path from Viper::Packages::PATH_NAME' do
  let(:pkg) { Viper::Package.new 'viper_debug' }
  before { Viper::Packages.store.clear }
  subject do
    File.stub(:exist?, true) do
    pkg.path 
    end
  end

  specify { subject.must_equal home_path('.viper/packages/viper_debug/') }
end

describe 'Viper::Packages::PACKAGE_PATH includes our home base' do
  subject { Viper::Packages::PACKAGE_PATH }

  specify { subject.must_equal [home_path('.viper/packages/')] }
end

describe 'load_viper_path debug' do
  let(:pkg) { Viper::Package.new 'viper_debug' }
  before { Viper::Packages.store.clear }
  subject do
    File.stub(:exist?, true) do
      pkg.viper_path 'load' 
    end
  end

  specify { subject.must_equal home_pkg_path('viper_debug', 'load.viper') }
end

describe 'load' do
  let(:pkg) { Viper::Package.new 'viper_debug' }
  before { Viper::Packages.store.clear }

  subject do
    File.stub(:exist?, true) do
      pkg.load 
    end
  end

  specify { subject }
end

describe 'lib_path' do
  let(:pkg) { Viper::Package.new 'viper_debug' }
  before { Viper::Packages.store.clear }
  subject do
    File.stub(:exist?, true) do
      pkg.lib_path 
    end
  end

  specify { subject.must_equal home_pkg_path('viper_debug', 'lib/') }
end

describe 'version_const_string' do
  let(:pkg) { Viper::Package.new 'viper_ruby' }
  before { Viper::Packages.store.clear }
  subject do
    File.stub(:exist?, true) do
      pkg.const_string 
    end
  end

  specify { subject.must_equal 'Viper::Packages::ViperRuby' }
end

# fake out Viper::Packages::ViperRuby::VERSION
module Viper
  module Packages
    module ViperRuby
      VERSION = '0.1.0'
    end
  end
end


describe 'version' do
  let(:pkg) { Viper::Package.new 'viper_ruby' }
  before do
    File.stub(:exist?, true) do
      Viper::Packages.store.clear; pkg.load 
    end
  end
  subject do 
      pkg.version 
  end

  specify { subject.wont_be_nil }
  specify { subject.wont_be_empty }
end

describe 'package_info raises Viper::Packages::PackageNotFound' do
  subject { package_info 'xyzzy' }

  specify { -> { subject }.must_raise Viper::Packages::PackageNotFound }
end

# Fake out Viper::Packages::ViperDebug::VERSION
module Viper
  module Packages
    module ViperDebug
      VERSION = '0.1.0'
    end
  end
end

describe 'package_info viper_debug' do
  let(:pkg) { Viper::Package.new 'viper_debug' }
  before do
    File.stub(:exist?, true) do
      Viper::Packages.store.clear; pkg.load 
    end
  end
  subject { package_info 'viper_debug' }

  specify { subject.must_equal 'Package name: viper_debug version: 0.1.0' }
  specify { Viper::Packages.store.length.must_equal 1 }
end

describe 'Viper::Packages[0]' do
  let(:pkg) { Viper::Package.new 'viper_debug' }
  before do
    File.stub(:exist?, true) do
      Viper::Packages.store.clear; pkg 
    end
  end
  subject { Viper::Packages[0] }

  specify { subject.must_be_instance_of Viper::Package }

end

describe 'Viper::Packages[0]=' do
  let(:pkg) { Viper::Package.new 'viper_debug' }
  before do
    File.stub(:exist?, true) do
      Viper::Packages.store.clear; pkg 
    end
  end
  subject { Viper::Packages[1] = pkg }

  specify { subject }
end
