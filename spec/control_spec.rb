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

describe 'intra_hooks' do
  before { @ranit = false; Viper::Session[:intra_hooks] ||= []; Viper::Session[:intra_hooks] << ->(_bind, _key, _value) { @ranit = true } }
  subject do
    Viper::Control.loop do |w|
      #      puts w.intra_hooks.inspect
      w.intra_hook(binding, :key_i, '')
      break
    end
  end

  specify { subject; @ranit.must_equal true }
end
