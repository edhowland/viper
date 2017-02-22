# delete_at.rb - class DeleteAt - command delete_at object index - removes
# element at index of object. Returns '' if not found, prints error on stderr

 class DeleteAt < BaseNodeCommand
   def call *args, env:, frames:
     perform args[0], env:env, frames:frames do |node|
      node.delete_at(args[1].to_i)
    end
     true
   end
 end
 
