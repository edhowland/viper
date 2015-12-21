# string_buffer_spec.rb - specs for string_buffer

require_relative 'spec_helper'

describe 'initialize' do
  subject { StringBuffer.new 'abcdef' }

  specify { subject.must_be_instance_of StringBuffer }
end
