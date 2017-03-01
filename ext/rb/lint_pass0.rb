# lint_pass0.rb - class LintPass0 - checks for indentations not even multiple
# of :indent

require_relative 'jsonify'
require_relative 'indentations'

class LintPass0 < BaseBufferCommand
  include Jsonify
  def call *args, env:, frames:
    jsonify args[0], pass_name:'lint_pass0', env:env, frames:frames do |lines|
      return [] if pragma(lines, pass_number:0)
      result = indentations(lines).map(&ennumber).
      reject {|e| (e[1] % frames[:indent].to_i).zero? }.
      map {|e| "line #{e[0]}: indented: #{e[1]}"}
    end
  end
end