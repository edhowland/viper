# lint_pass2.rb - class LintPass2 - command lint_pass2 buf - checks for trailing
# whitespace

require_relative 'jsonify'

class LintPass2 < BaseBufferCommand
  include Jsonify

  def call *args, env:, frames:
    jsonify args[0], pass_name:'lint_pass2', env:env, frames:frames do |buffer|
      lines = buffer.lines

      result = lines.map do |e|
        m = e.match /( *)$/
    m[1].nil? ? 0 : m[1].length
      end.
      map(&ennumber).
      reject {|e| e[1].zero? }
    end
  end
end