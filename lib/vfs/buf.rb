# buf.rb - Initials virtual FS with /buf/0, at least

Viper::VFS['buf'] = { "0" => ScratchBuffer.new }
