# capture.rb - class Capture - command capture

# standalone version
# temp cpt version - rename to class Capture

class Cpt < BaseCommand
  def initialize
    super
    @defaults = [
      ->(env:, frames:) { wrong_type_num(env:env); false },
      ->(env:, frames:) { false },
      ->(env:, frames:) { true }
    ]
  end

  def wrong_type_num env:
    error "Wrong type or number of arguments. Expected 1 to 3 1 blocks", env:env
  end

  def call *args, env:, frames:
    trial = @defaults.zip(args).map {|e| e.select {|f| f.respond_to?(:call) } }.map {|e| e[-1] }
    prosecute, sentence, justice = trial
    begin
      env.push
      result = prosecute.call(env:env, frames:frames)
    rescue => err
      env.pop
      frames.first[:last_exception] = err.message
      result = false
      sentence.call(env:env, frames:frames)
    ensure
      env.pop unless env.length <= 1
      justice.call(env:env, frames:frames)
    end

    result
  end
end
