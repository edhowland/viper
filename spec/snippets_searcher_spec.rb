# snippets_searcher_spec.rb - specs for snippets_searcher

require_relative 'spec_helper'

def my_path(path)
  File.expand_path(File.dirname(File.expand_path(__FILE__)) + "/../config/#{path}")
end

def tilde_path(path)
  File.expand_path("~/.viper/snippets/#{path}")
end

describe 'config_path' do
  subject { Viper::Snippets::Searcher.config_path 'default' }

  specify { subject.must_equal my_path('default.json') }
end

describe 'home_path' do
  subject { Viper::Snippets::Searcher.home_path 'default' }

  specify { subject.must_equal tilde_path('default.json') }
end
