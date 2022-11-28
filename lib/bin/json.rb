# json.rb - class Json - command json - converts VfsNodes to JSON
# with argument '-r' reads JSON from stdin and creates VFSNodes and appends to
# args[0] - first arg

require 'json'

def to_vfs(parent, name, h)
  node = VFSNode.new(parent, name)
  h.each do |k, v|
    node[k] = if Hash === v
                to_vfs(node, k, v)
              else
                if v.instance_of? String
                  StringIO.new(v)
                else
                  v
                end
              end
  end
  node
end

class Json < BaseNodeCommand
  def call(*args, env:, frames:)
    a = args_parse! args
      if @options[:r]
        perform_new a[0], env: env, frames: frames do |node, base|
          child = to_vfs(node, base, JSON.parse(env[:in].read))
          node[child.name] = child
          ''
        end
      else
        perform args[0], env: env, frames: frames do |node|
          node.to_h.to_json
        end
      end

  end
end
