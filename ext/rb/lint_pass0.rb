# lint_pass0.rb - class LintPass0 - checks for indentations not even multiple
# of :indent

require_relative 'jsonify'
require_relative 'indentations'

class LintPass0 < BaseBufferCommand
  include Jsonify
  def call *args, env:, frames:
    jsonify args[0], env:env, frames:frames do |buffer|
      lines = buffer.lines
      a = 0
      maker = ->(e) { [a+=1, e] }

      result = indentations(lines).map(&maker).
      reject {|e| (e[1] % frames[:indent].to_i).zero? }.
      map {|e| "line #{e[0]}: indented: #{e[1]}"}
      if result.empty?
        nil
      else
        { lint_pass0: result }.to_json
      end
    end
  end
end