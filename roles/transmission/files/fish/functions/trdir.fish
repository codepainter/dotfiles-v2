function trdir --description 'Process Torrent. Usage: trdir <src_dir>'

    set -q src_dir $argv[1]
    or set src_dir $PWD

    # start transmission-daemon if not running
    if ! pgrep -x "transmission-daemon" > /dev/null
        echo "Starting transmission-daemon"
        transmission-daemon
    end

    for f in $src_dir/*.torrent
        echo "Processing $f"
        transmission-remote -a $f
    end

    transmission-remote -l -st

end