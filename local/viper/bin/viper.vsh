rem viper.vsh loads scripts and set path for buffer node commands
mkdir /v/viper/bin
cmdlet viper_commands '{ ::BinCommand::ViperCommand.descendants.each {|k| out.puts k.name } }'
for k in :(viper_commands) { install_cmd :k /v/viper/bin }
path="/v/viper/bin::{path}"; global path
