# shell.rb - method shell runs a command returning stdout, stderr

# run command piping value from block to stdin, return stdout, stderr
def shell command, &_blk
  output, error = ''
  begin
  stdin, stdout, stderr = Open3.popen3(command)
  yield stdin if block_given?
  stdin.close
  output = stdout.read
  error = stderr.read
  ensure
    stdout.close
    stderr.close
  end

  [output, error]
end

def pipe buffer, *command
  command = command.join(' ')
  output, error = shell(command) do |input|
    input.write(buffer.to_s)
  end

  say output
  say error
end

# pipe contents through command, replacing contents with stdout
def pipe! buffer, *command
  command = command.join(' ')
  output, error = shell(command) do |input|
    input.write(buffer.to_s)
  end

  buffer.overwrite! output

end

def insert_shell buffer, *command
  command = command.join(' ')
  output, error = shell(command)
  buffer.ins output
end
