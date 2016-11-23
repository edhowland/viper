source scripts.vsh
source debug.vsh
source meta.vsh
run=com
test -z :argv || run=vip
test -z :argv || exec {
for f in :(reverse :argv) { fopen :f }
}
:run 1
cat < /v/command > command.hist

