# lint_pass3.rb - counts and points out excessive blank lineage

require_relative 'jsonify'
require_relative 'distance'

class LintPass3 < BaseCommand
  include Jsonify

  def call *args, env:, frames:
    jsonify args[0], pass_name:'3', env:env, frames:frames do |lines|
      adjacents(lines.map(&:chomp).map(&:length).map {|e| e.zero? ? :ok : nil }).
      map {|e| e[0] == :ok && e[1] == :ok }.map(&ennumber).select {|e| e[1] }.map {|e| e[0] }
    end
  end
end