# at - class At - command at
# reports character at current cursor

class At < BaseBufferCommand
      def call *args, env:, frames:
    buf_apply(args[0], env:env, frames:frames) {|buffer| @meth0.call buffer }
  end
end

