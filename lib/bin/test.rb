# test - class Test - command test - returns true or false based on  arguments
# args:
# (no flags: tests if first arg is true
# -f checks if file exists. TODO: should check only if file and not directory. MUST FIX (See -X
# -d  checks if argument is a directory
# -z checks if argument is empty string
# -e checks if array or directory  is empty
# -l true if arg is a Lambda or if VFS path points to stored lambda
# -b checks if arg is a code block or if VFS path points to tored code block
# -x checks if pathname resolves to executable content
#   Is the pathname a stored lambda or code block? or a binary command
# -X (file and not dir) ; TODO: move this to -f. -X becomes what -f is today

class Test < BaseCommand
  def fs_object(path, frames:)
if Hal.exist?(path)
          root = frames[:vroot]
        node = root[path]
    node
        else
          false
        end    
  end
  def executable?(obj, klass_set=[Block, Lambda])
    klass_set.reduce(false) {|i, j| i || obj.kind_of?(j) }
    #klass_set.to_set.member?(obj.class)
  end
  def obj_or_path_executable?(obj, klass_set=[Block, Lambda], frames:)
    executable?(obj, klass_set) ||  (obj.instance_of?(String) && Hal.exist?(obj) && Hal.virtual?(obj) && executable?(fs_object(obj, frames: frames), klass_set))
    #executable?(Hal.exist?(obj) && Hal.virtual?(obj) && fs_object(obj, frames:frames), klass_set)
  end
  def call(*args, env:, frames:)
    super do |*a|
      result = false
      if @options[:f]
        result = Hal.exist?(a[0])
      elsif  @options[:d]
        result =  Hal.directory?(a[0])
      elsif @options[:x]
        result = obj_or_path_executable?(a[0], [Block, Lambda, BaseCommand, CommandLet], frames: frames)


      elsif @options[:z]
        result = (a[0].nil? || a[0].empty?)
      elsif  @options[:e]
      if a.length == 0
        env[:err].puts "test -e: must have exactly one argument"
        return false
      end
        root = frames[:vroot]
        node = root[a[0]]
      if node.nil?
        return false
      end
        result = node.empty?
      elsif @options[:l]
        result = obj_or_path_executable?(a[0], [Lambda], frames: frames)
      elsif @options[:b]
        result = obj_or_path_executable?(a[0], [Block], frames: frames)
    elsif @options[:X]
      result = Hal.exist?(a[0]) && !Hal.directory?(a[0])
      else
        result = a[0]
      end
      result
    end
  end
end
