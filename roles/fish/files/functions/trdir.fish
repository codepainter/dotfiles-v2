function trdir --description 'Process Torrent. Usage: trdir <src_dir>'

    set -q src_dir $argv[1]
    or set src_dir $PWD

    echo "Processing .torrent files in $src_dir" 

    for f in $src_dir/*.torrent
        echo "Processing $f"
        transmission-remote -a $f
    end

end