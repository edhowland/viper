# index_of.rb - class IndexOf - command index_of object string - returns index
# of found element. returns '' and stderr error message if not found

class IndexOf < BaseNodeCommand
  def call(*args, env:, frames:)
    perform args[0], env: env, frames: frames do |node|
      result = node.index((args[1] + "\n"))
      if result.nil?
        result = ''
        env[:err].puts 'index_of: element not found'
      end
      result
    end
  end
end
