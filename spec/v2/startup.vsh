source scripts.vsh
source debug.vsh
run=com
test -z :argv || run=vip
test -z :argv || exec {
for f in :(reverse :argv) { fopen :f }
}
:run
cat < /v/command > command.hist

