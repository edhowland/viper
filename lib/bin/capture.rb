# capture.rb - class Capture - command capture
# rubocop:disable Style/Semicolon

class Capture < BaseCommand
  def initialize
    super
    @defaults = [
      ->(env:, **_keys) { wrong_type_num(env: env); false },
      ->(**_keys) { false },
      ->(**_keys) { true }
    ]
  end

  def trial(args)
    @defaults.zip(args)
             .map { |e| e.select { |f| f.respond_to?(:call) } }
             .map { |e| e[-1] }
  end

  def wrong_type_num(env:)
    error 'Wrong type or number of arguments. Expects 1 to 3 1 blocks', env: env
  end

  def call(*args, env:, frames:)
    prosecute, sentence, justice = trial args
    begin
      env.push
      result = prosecute.call(env: env, frames: frames)
    rescue VirtualMachine::ExitCalled => err
      env.pop
      raise err

    rescue => err
      env.pop
      frames.first[:last_exception] = err.message
      result = false
      sentence.call(env: env, frames: frames)
    ensure
      env.pop unless env.length <= 1
      justice.call(env: env, frames: frames)
    end
  frames.merge
    result
  end
end
