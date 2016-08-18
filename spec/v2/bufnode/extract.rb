# extract.rb - class Extract - command extract - contents of node 
# are extracted, clearead and output


class Extract < BaseNodeCommand
  def call *args, env:, frames:
    perform(args[0], env:env, frames:frames) do |node|
      tmp = node.join('')
      node.clear
      tmp
    end
  end
end
