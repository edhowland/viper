# subtree - class Subtree - command subtree - grabs eepth sub nodes
# and sends to stdout


class Subtree < BaseNodeCommand
  def call *args, env:, frames:
    if args.empty?
      env[:err].puts 'subtree: must supply depth argument'
      false
    else
      depth = args[0].to_i
      root = frames[:vroot]
      node = root.wd
      env[:out].puts node['line'].string
      depth -= 1
      # recurse down max depth
      node = node['nl']
      until depth <= 0 || node.nil?
        env[:out].puts node['line'].string
        depth -= 1
        node = node['nl']
      end
      true
    end
  end
end
