# rotate - class Rotate - command rotate - used on things like :
# /v/modes/viper/metadata/buffers
# args:
# -r : reverse rotates
# rubocop:disable Style/Semicolon

class Rotate < BaseNodeCommand
  def call(*args, env:, frames:)
    a = args_parse! args
    if @options[:r]
      perform(a[0], env: env, frames: frames) { |node| node.rotate!(-1); '' }
    else
      perform(a[0], env: env, frames: frames) { |node| node.rotate!; '' }
    end
  end
end
