# rotate - class Rotate - command rotate - used on things like :
# /v/modes/viper/metadata/buffers

class Rotate < BaseNodeCommand
  def call *args, env:, frames:
    super do |*a|
      if @options[:r]
        perform(a[0], env:env, frames:frames) {|node| node.rotate! -1; '' }
      else
        perform(a[0], env:env, frames:frames) {|node| node.rotate!; '' }
      end
    end
  end
end
