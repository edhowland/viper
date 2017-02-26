# lint_pass2.rb - class LintPass2 - command lint_pass2 buf - checks for trailing
# whitespace

class LintPass2 < BaseBufferCommand
  def call *args, env:, frames:
    buf_apply args[0], env:env, frames:frames do |buffer|
      #nil
      ''
    end
  end
end