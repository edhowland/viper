# non_writable_spec.rb - specs for non_writable

require_relative 'spec_helper'

class CannotWriteMe < Buffer
  include NonWritable
end


describe 'NonWritable' do
  let(:buf) { CannotWriteMe.new }
end
