function ziptocbz --description 'zip all files in a directory to cbz. Usage: ziptocbz [directory]'

    set -q src_dir $argv[1]
    or set src_dir $PWD

    cd $src_dir

    for x in */
         set x (string trim -c "/" $x);
         zip -rmv $x.cbz $x;
     end
end