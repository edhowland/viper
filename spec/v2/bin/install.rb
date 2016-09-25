# install - class Install - command install - install commands to /v/bin
# Based on descendents of BaseCommand.
# This command is purposely NOT a descendent of BaseCommand

class Install
  def call *args, env:, frames:
    root=frames[:vroot]
    path = root['/v/bin']  # commands will be installed here
    BaseCommand.descendants.each do |klass|
      path[klass.name.downcase] = klass.new
    end
    true
  end
end

