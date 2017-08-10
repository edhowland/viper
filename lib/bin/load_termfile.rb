# load_termfile.rb - class LoadTermfile - command load_termfile -  
# reads and parses  first argument as JSON file and  loads resultant hash into 
# variable :metakeys

class LoadTermfile < BaseCommand
  def call *args, env:, frames:
    if args.length != 1
      env[:err].puts 'load_termfile: expected filename argument'
      return false
    else
      frames.first[:metakeys] = parse_termfile(args[0])
    end
    true
  end
end
