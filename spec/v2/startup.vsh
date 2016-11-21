source editor.vsh
source command.vsh
source viper.vsh
source search.vsh
source delete.vsh
source debug.vsh
test -z :argv || exec {
for f in :(reverse :argv) { fopen :f }
vip
}

