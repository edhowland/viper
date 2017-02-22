# require.rb - class  Require - command require path_file.rb or gem

class Require < BaseCommand
  def call *args, env:, frames:
    path = args[0].pathmap('%d/%f')
    if Hal.exist? path
      require path
      true
    else
      env[:err].puts "#{path}: File not found"
      false
    end
  end
end