# lint_pass1.rb - class LintPass1 - looks at buffer and reports adjacent indent
# offsets > 0, :indent level

require_relative 'indentations'
require_relative 'distance'

class LintPass1 < BaseBufferCommand
  def call *args, env:, frames:
    buf_apply(args[0], env:env, frames:frames) do |buffer|
      lines = buffer.lines
      a = 0
      maker = ->(e) { [a+=1, e] }
      env[:out].puts distance(indentations lines).map(&:abs).map(&maker).reject {|e| e[1].zero? }.reject {|e| e[1] == frames[:indent].to_i }.map {|e| "line #{e[0]},#{e[0] + 1}: offset: #{e[1]}" }.join("\n")
      ''
    end
  end
end