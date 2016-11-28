# j2 - class J2 - command j2 - converts VfsNodes to JSON

 class J2 < BaseNodeCommand
   def call *args, env:, frames:
     perform args[0], env:env, frames:frames do |node|
      node.to_h.to_json
    end
   end
 end
