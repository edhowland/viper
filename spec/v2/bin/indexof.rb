# indexof - class Indexof - command indexof -
# args
# character 
# reads stream from stdin, outputs charcter positon if found
# returns true if found, else false

class Indexof < BaseCommand
  def call *args, env:, frames:

    super do |*a|

      var = @in.read.index(a[0][0])
      result = !var.nil?
      if result
        pout "#{var}"
      end
      result
    end
  end
end

