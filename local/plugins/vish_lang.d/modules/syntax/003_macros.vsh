rem macros.vsh load JSON file for macro processing
json -r /v/macros/.vsh < ":{vish_lang_dir}/macros/vish.json"
function dumpvsh() {
jpath=":{vhome}/ext/vsh/vish.json"
json /v/macros/.vsh > :jpath
}
