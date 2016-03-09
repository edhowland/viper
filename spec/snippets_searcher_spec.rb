# snippets_searcher_spec.rb - specs for snippets_searcher

require_relative 'spec_helper'

def my_path path
  File.expand_path(File.dirname(File.expand_path(__FILE__)) + "/../config/#{path}")
end


describe 'locate' do
  subject { Viper::Snippets::Searcher.locate 'default' }

  specify { subject.must_equal my_path('default.json') }
end
