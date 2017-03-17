# lint_pass4.rb - class LintPass4 - command lint_pass4 :_buf
# checks for lines longer thant :lint_max_length

require_relative 'jsonify'

class LintPass4 < BaseBufferCommand
  include Jsonify

  def call(*args, env:, frames:)
    jsonify args[0], pass_name: '4', env: env, frames: frames do |lines|
      maxima = frames[:lint_max_length]
      maxima = maxima.empty? ? 80 : maxima.to_i
      lines.map(&:chomp).map(&:length).map(&ennumber).reject { |e| e[1] <= maxima }
    end
  end
end
