# clip.rb - buffer /clip/*

scratch = ScratchBuffer.new
scratch.name = 'Clip 0'
Viper::VFS["clip"] = { "0" => scratch }
