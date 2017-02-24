# lint_pass0.rb - class LintPass0 - checks for indentations not even multiple
# of :indent

require_relative 'indentations'

class LintPass0 < BaseBufferCommand
  def call *args, env:, frames:
    buf_apply args[0], env:env, frames:frames do |buffer|
      lines = buffer.lines
      a = 0
      maker = ->(e) { [a+=1, e] }
      { lint_pass0: indentations(lines).map(&maker).reject {|e| (e[1] % frames[:indent].to_i).zero? }.map {|e| "line #{e[0]}: indented: #{e[1]}" } }.to_json
    end
  end
end