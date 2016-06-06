# viper.rb - VFS /viper - root of virtual FS

Viper::VFS["viper"] = {
  "classes" => {
    "buf" => Buffer,
    "clip" => ScratchBuffer,
    "mode" => String,
    "viper" => String
  },
  'variables' => Viper::Variables.storage,
  "alias" => { "hello" => "say hello world" }
}

