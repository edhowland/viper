# lint_pass1.rb - class LintPass1 - looks at buffer and reports adjacent indent
# offsets > 0, :indent level
require_relative 'jsonify'
require_relative 'indentations'
require_relative 'distance'

class LintPass1 < BaseBufferCommand
  include Jsonify

  def combine
    p = ennumber
    ->(e) { p.call(e.length) + [indented(e)] }
  end

  def call *args, env:, frames:
    jsonify(args[0], pass_name:'lint_pass1', env:env, frames:frames) do |buffer|
      lines = buffer.lines
      interim = lines.map(&:chomp).map(&combine).
        reject {|e| e[1].zero? }.map {|e| [e[0], e[2]] }
      adjacents(interim).map {|e| [e[0][0], (e[0][1] - e[1][1]).abs ] }.reject {|e| e[1] == 0 || e[1] == frames[:indent].to_i }
    end
  end
end