# ins_at.rb - class InsAt - command ins_at :_buf string - inserts string  forward


class InsAt < BaseBufferCommand
  def call *args, env:, frames:
    if args.length == 1
      object = env[:in].read
    else
      object = args[1]
    end
    perform(args[0], env:env, frames:frames) do |node|
      buffer = node['buffer']

       #buffer.ins object
      @meth.call buffer, object
      object
    end
  end
end