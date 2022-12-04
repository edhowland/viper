rem load all scripts in ./local/vish/prelude/
cd ":{__DIR__}/prelude"; for s in ???_*.vsh { source :s }; suppress { cd - }
