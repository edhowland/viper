# control_spec.rb - specs for control

require_relative 'spec_helper'

describe 'gets exception' do
  subject do
    Viper::Control.loop do |_w|
      fail BindingNotFound.new
    end
  end

  specify { subject }
end
