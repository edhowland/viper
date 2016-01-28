# path_shortener_spec.rb - specs for path_shortener

require_relative 'spec_helper'

describe 'path_shortener full' do
  subject { path_shortener(File.expand_path(__FILE__)) }

  specify { subject.must_equal '.../src/viper/spec/path_shortener_spec.rb' }
end
