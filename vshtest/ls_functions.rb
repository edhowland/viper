# ls_functions.rb - class LsFunctions - command ls_functions - prints all 
# current function names

class LsFunctions < BaseCommand
  def call *args, env:, frames:
    frames.functions.keys.each do |fn|
      env[:out].puts fn
    end
    true
  end
end