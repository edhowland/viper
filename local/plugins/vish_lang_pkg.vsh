rem vish_lang_pkg.vsh The Vish language plugin
vish_lang_file=:__FILE__; vish_lang_dir=":{__DIR__}/vish_lang.d"
touch /v/known_extensions/vsh
mpath=":{vish_lang_dir}/modules" import syntax
function who_am_i() {
  echo I am in :vish_lang_file in :vish_lang_dir
}