# cp.rb - class Cp - command cp src dest -

class Cp < BaseCommand
  def call(*args, env:, frames:)
    src, dest = args
    if src.nil? || dest.nil?
      env[:err].puts 'mv: wrong # of arguments. mv src dest'
      return false
    end
    Hal.cp src, dest
    true
  end
end
