function wgnc -d 'wget with --content-disposition'
    wget --limit-rate 1536k -nc --content-disposition $argv
end