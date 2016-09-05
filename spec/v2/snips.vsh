function assoc.buf(name) {
touch ":{_buf}/.association"
echo :name > ":{_buf}/.association"
}
function assoc() {
cat < ":{_buf}/.association"
}
