# lint_pass1.rb - class LintPass1 - looks at buffer and reports adjacent indent
# offsets > 0, :indent level

require_relative 'indentations'
require_relative 'distance'

class LintPass1 < BaseBufferCommand
  def call *args, env:, frames:
    buf_apply(args[0], env:env, frames:frames) do |buffer|
      lines = buffer.lines
      distance(indentations lines).map(&:abs).reject(&:zero?).reject {|e| e == frames[:indent].to_i }
    end
  end
end