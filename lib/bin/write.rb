# write.rb - class  Write - command write variable - outputs contents of var

class Write < BaseCommand
  def call *args, env:, frames:
    unless args.length == 1
      env[:err].puts 'write: missing argument' 
      return false
    end
    
    env[:out].print frames[args[0].to_sym]
    true
  end
end
