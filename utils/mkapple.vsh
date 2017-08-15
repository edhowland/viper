load_termfile ":{vhome}/etc/keymaps/Apple_Terminal.json"
function rk() {
  echo -n Press key without holding alt key
  key=:(raw -)
  echo you pressed :key
  echo -n Now hold down alt key and press the :key again
  meta=:(raw - | xfkey -d)
  echo you got for "meta_:{key}"
  echo ...
  echo :meta
}
