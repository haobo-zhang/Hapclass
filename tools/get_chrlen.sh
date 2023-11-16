awk 'BEGIN{OFS="\t"}{if ($0~/>/) {chrName=$1; sub(">","", chrName);} else print chrName,length}' origin.fa >chr.len
