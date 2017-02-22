# is_empty.rb - class IsEmpty - command is_empty object -  true if object.empty?

class IsEmpty < BaseNodeCommand
  def call *args, env:, frames:
    result = true
    perform(args[0], env:env, frames:frames) do |node|
      unless node.respond_to? :empty?
        env[:err].puts "cannot check if #{args[0]} is empty"
        return false
      end
      result = node.empty?
      ''
    end
    result
  end
end
