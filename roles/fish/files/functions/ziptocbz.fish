function ziptocbz
    for x in */
         set x (string trim -c "/" $x);
         zip -rmv $x.cbz $x;
     end
end