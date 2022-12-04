rem argparse.vsh attempt to get the CLI arguments into argc and argv
cmdlet mkargc '{ globals[:argc] = ARGV.length }'
cmdlet mkargv '{ globals[:argv] = ARGV }'
mkargc; mkargv

