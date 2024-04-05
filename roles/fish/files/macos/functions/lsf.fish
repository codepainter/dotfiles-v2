function lsf -d "List files in a directory"
    ls -haltr | grep $argv[1]
end
