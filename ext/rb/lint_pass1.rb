# lint_pass1.rb - class LintPass1 - looks at buffer and reports adjacent indent
# offsets > 0, :indent level
require_relative 'jsonify'
require_relative 'indentations'
require_relative 'distance'

class LintPass1 < BaseBufferCommand
  include Jsonify

  def call *args, env:, frames:
    jsonify(args[0], pass_name:'lint_pass1', env:env, frames:frames) do |buffer|
      lines = buffer.lines
      distance(indentations lines).map(&:abs).map(&ennumber).reject {|e| e[1].zero? }.reject {|e| e[1] == frames[:indent].to_i }.map {|e| "line #{e[0]},#{e[0] + 1}: offset: #{e[1]}" } 
    end
  end
end