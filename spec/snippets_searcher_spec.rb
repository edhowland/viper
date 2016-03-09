# snippets_searcher_spec.rb - specs for snippets_searcher

require_relative 'spec_helper'

def my_path path
  "/home/vagrant/src/viper/config/#{path}"
end


describe 'locate' do
  subject { Viper::Snippets::Searcher.locate 'default' }

  specify { subject.must_equal my_path('default.json') }
end
