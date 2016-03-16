# repl_spec.rb - specs for repl

require_relative 'spec_helper'

describe 'repl assertions' do
  before { Viper::Session[:commands] = command_bindings }
  describe 'non-existant command raises CommandNotFound' do
    subject {  exec_cmd(:xyzzy, nil) }

    specify {  -> { subject }.must_raise CommandNotFound }
  end

  describe 'will execute command if it exists passing 1 arg' do
    before { Viper::Session[:commands][:babel] = ->(_b, *args) { args[0] } }
    subject { exec_cmd :babel, nil, 'ABCD' }

    specify { subject.must_equal 'ABCD' }
  end

  describe 'perform! babel fish' do
    before { Viper::Session[:commands][:babel] = ->(_b, *args) { args[0] } }
    subject { perform!('babel fish') { nil } }

    specify { subject.must_equal 'fish' }
  end

  describe 'perform! command (only)' do
    before { Viper::Session[:commands][:babel] = ->(_b, *_args) { 'ok' } }
    subject { perform!('babel') { nil } }

    specify { subject.must_equal 'ok' }
  end

  describe 'perform! empty string' do
    let(:buf) { Buffer.new '' }
    subject { perform!('') { buf } }

    specify { subject }
  end

  # actual functional test of repl
  describe 'repl :quit' do
    before { $stdin = StringIO.new 'q' }
    let(:buf) { Buffer.new '' }
    subject { repl { buf } }

    specify { subject.must_equal :quit }
  end

  describe 'repl nop returning dequoted string' do
    before { $stdin = StringIO.new 'nop "hello world"' }
    let(:buf) { Buffer.new '' }
    subject { repl { buf } }

    specify { subject.must_equal 'hello world' }
  end

  describe 'command_verified? false' do
    let(:sexp) { [[:xxx, []]] }
    subject { command_verified? sexp }

    specify { subject.must_equal false }
  end

  describe 'command_verified? true' do
    let(:sexp) { [[:nop, %w(1 2)]] }
    subject { command_verified? sexp }

    specify { subject.must_equal true }
  end

  describe 'repl with unknown command raises exception' do
    let(:buf) { Buffer.new '' }
    let(:combuf) { Viper::Readline.new }
    before { $stdin = StringIO.new 'xxx' + "\r" }
    subject { repl(combuf) { buf } }

    specify { -> { subject }.must_raise CommandNotVerified }
  end

end # top level repl assertions describe
