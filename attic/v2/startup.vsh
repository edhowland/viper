source scripts.vsh
source debug.vsh
source meta.vsh
run=com
test -z :argv || run=vip
test -z :argv || exec {
for f in :(reverse :argv) { fopen :f }
echo -n buffer :(basename :_buf)
}
load_event
meta :run
cat < /v/command > command.hist

