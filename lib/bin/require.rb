# require.rb - class  Require - command require path_file.rb or gem

class Require < BaseCommand
  def call(*args, env:, frames:)
    path = Hal.realpath(args[0])   #.pathmap('%d/%f')
    if Hal.exist? path
      require path
      true
    else
      env[:err].puts "#{path}: File not found"
      false
    end
  rescue SyntaxError => err
    env[:err].puts "SyntaxError: #{err.message}"
  rescue => err
    env[:err].puts err.class.name, err.message
  end
end
