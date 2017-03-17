# vfs_node - class VFSNode - A node in a VFS tree

class Hash; def identy
              :to_h
            end; end

class String; def identy
                :to_s
              end; end

class Array; def identy
               :to_a
             end; end

class VFSNode
  def initialize(parent, name)
    @name = name
    @parent = parent
    @list = {}
  end
  attr_accessor :list, :parent, :name

  def empty?
    @list.empty?
  end

  def mknode(name)
    @list[name] = VFSNode.new(self, name)
  end

  def [](key)
    return parent if key == '..'
    @list[key]
  end

  def []=(key, value)
    @list[key] = value
  end

  def keys
    @list.keys
  end

  def pathname
    gather = [@name]
    node = @parent
    until node.nil?
      gather << node.name
      node = node.parent
    end
    gather.reverse.join('/')
  end

  def to_s
    "directory node: #{@name}"
  end

  def identy
    :to_h
  end

  def to_h
    @list.to_a.each_with_object({}) { |e, h| h[e[0]] = e[1].send(e[1].identy) }
  end

  def deep_clone
    that = self.class.new @parent, @name
    @list.each_pair do |k, v|
      that.list[k] = cloner(v)
    end
    that
  end
end
