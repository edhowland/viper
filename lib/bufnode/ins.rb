# ins - class Ins - command ins - inserts either stdin or arg into line

class Ins < BaseBufferCommand
  def call(*args, env:, frames:)
    object = if args.length == 1
               env[:in].read
             else
               args[1]
             end
    perform(args[0], env: env, frames: frames) do |node|
      buffer = node['buffer']

      @meth.call buffer, object
      object
    end
  end
end
