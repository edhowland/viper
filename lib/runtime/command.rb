# command - class Command - factory class to resolve identifiers into actual
# runnable commands, aliases or functions
# rubocop:disable Lint/ShadowingOuterLocalVariable
# Intentionally ignore @@cached. There must be only one
# rubocop:disable Style/ClassVars
# logic herein does not support guard clause
# rubocop:disable Style/GuardClause
# rubocop:disable Metrics/AbcSize
# rubocop:disable Metrics/CyclomaticComplexity
# rubocop:disable Metrics/PerceivedComplexity

class CommandNotFound < RuntimeError
  def initialize(command = 'unknown', line_number:0)
    super "Command: #{command}: not found: #{line_number}"
  end
  attr_accessor :line_number
end

class Command
  class << self
    def path_str(frames:)
      frames[:path]
    end
    def first_in_path(cmd, frames:)
    #binding.pry
      found = path_str(frames: frames).split(':').detect {|e|command_from_path("#{e}/#{cmd}", frames: frames) } 
      unless found.nil?
        "#{found}/#{cmd}"
      else
        found
      end
    end
    def command_from_path(path, frames:)
      root = frames[:vroot]
      root[path]
    end

    # fake it till you make it
    def resolve(id, env:, frames:, line_number:0)
      @@cache ||= {}
      return Null.new if id.nil? || id.empty?
      id = '_break' if id == 'break'
      id = '_return' if id == 'return'

      fn = frames.functions[id]
      return fn unless fn.nil?
      if frames.vm.respond_to? id.to_sym
        return lambda do |*args, env:, frames:|
          frames.vm.send id.to_sym, *args, env: env, frames: frames
        end
      end
      begin
        thing = @@cache[id.to_sym]
        if thing.nil?
          #cpath = "/v/bin/#{id}"
          cpath = id
          thing = command_from_path first_in_path(cpath, frames: frames), frames: frames
        end
        if thing.nil?
          raise CommandNotFound.new(id, line_number:line_number) 
        else
          @@cache[id.to_sym] ||= thing
          return thing
        end
      rescue => err
        env[:err].puts err.message # "Command: #{id}: not found"
        False.new
      end
    end
  end
end
