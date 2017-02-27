# lint_pass3.rb - counts and points out excessive blank lineage

require_relative 'jsonify'
require_relative 'distance'



class LintPass3 < BaseCommand
  include Jsonify
  
  def call *args, env:, frames:
    jsonify args[0], pass_name:'lint_pass3', env:env, frames:frames do |buffer|
      lines = buffer.lines
      adjacents(lines.map(&:chomp).map(&:length).map {|e| e.zero? ? :ok : nil }).
        map {|e| e[0] == e[1] }.map(&ennumber).select {|e| e[1] }.map {|e| e[0] }
    end
  end
end