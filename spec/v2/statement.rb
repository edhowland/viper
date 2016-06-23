# statement - classStatement - statement node in AST

# Represents a statement of the form:
# [var=val ...] command [arg1 arg2 ...] [redirection_op target ...] (# comment)?
# At runtime, the statement proceeds in 2 phases:
# Phase I : Evaluate all the command expansion/substitution stuff
# Phase II : Having the context proceed as if the substitutions were substituted. Run the command
class Statement
  def initialize assignments:, command:NullCommand.new, arguments:, redirections:
    @assignments = assignments
    @command = command
    @args = arguments
    @redirects = redirections
  end

  # proceeding in the phase order:
  # set up assignments, redirects and args
  # Then pass a block to redirection_list.call
  def call frames:
#binding.pry
    locals = frames.clone
    locals.push
    @assignments.call frames:locals
    args = @args.call frames:frames   # duplicating bash behaviour
    @redirects.call outer_frames:frames, frame:locals do |e, f|
      @command.call args, env:e, frames:f
    end
  end
end

