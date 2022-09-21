# test - class Test - command test - returns true or false based on  arguments
# args:
# (no flags: tests if first arg is true
# -f checks if file exists
# -d  checks if argument is a directory
# -z checks if argument is empty string
# -e checks if array or directory  is empty
# -l true if arg is a Lambda or if VFS path points to stored lambda
# -b checks if arg is a code block or if VFS path points to tored code block
# -x checks if pathname resolves to executable content
#   Is the pathname a stored lambda or code block?

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
  def call(*args, env:, frames:)
    super do |*a|
      result = false
      if @options[:f]
        result = Hal.exist?(a[0])
      elsif  @options[:d]
        result =  Hal.directory?(a[0])
      elsif @options[:x]
        node = fs_object(a[0], frames: frames)
        if node != false
        result = (node.kind_of?(Lambda) || node.kind_of?(Block) || node.kind_of?(BaseCommand))
        else
          result = false
        end
      elsif @options[:z]
        result = (a[0].nil? || a[0].empty?)
      elsif  @options[:e]
        root = frames[:vroot]
        node = root[a[0]]
        result = node.empty?
      elsif @options[:l]
        result = (Lambda === a[0])
        if !result
          node = fs_object(a[0], frames: frames)
          result = (Lambda === node)
        end

      elsif @options[:b]
        result = (Block === a[0])
        if !result
          node = fs_object(a[0], frames: frames)
          result = ( Block === node)
        end
        
      else
        result = a[0]
      end
      result
    end
  end
end
