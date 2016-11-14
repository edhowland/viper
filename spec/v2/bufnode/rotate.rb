# rotate - class Rotate - command rotate - used on things like :
# /v/modes/viper/metadata/buffers

class Rotate < BaseNodeCommand
  def call *args, env:, frames:
    perform args[0], env:env, frames:frames do |node|
      node.rotate!
      ''
    end
  end
end

