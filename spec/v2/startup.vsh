source editor.vsh
source viper.vsh
source search.vsh
source delete.vsh
source debug.vsh
for f in :(reverse :argv) { fopen :f }
vip

