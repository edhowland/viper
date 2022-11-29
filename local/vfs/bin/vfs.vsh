rem vfs.vsh loads VFS commands and sets path
mkdir /v/vfs/bin
cmdlet vfs_commands '{ ::BinCommand::VFSCommand.descendants.each {|k| out.puts k.name } }'
for k in :(vfs_commands) { install_cmd :k /v/vfs/bin }
path="/v/vfs/bin::{path}"; global path
