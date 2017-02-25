# indexof - class Indexof - command indexof -
# args
# character 
# reads stream from stdin, outputs character position if found
# -r : reverses the search with rindex
# returns true if found, else false

class Indexof < BaseCommand
  def regexp string
    if string[0] == '/'
      Regexp.new string[1..-2]
    else
      Regexp.new string
    end
  end

  def call *args, env:, frames:
    super do |*a|
      method = (@options[:r] ? :rindex : :index)
      regex = regexp a[0]
      var = @in.read.send(method, regex)
      result = !var.nil?
      if result
        pout "#{var}"
      end
      result
    end
  end
end

