perl tools/convertIndelVcfToCSV.pl $1.recode.vcf #将切割好的vcf文件转化
sed -i 's/\t/ /g' $1.recode.vcf.csv
 Rscript ./tools/MakeHeatmap_V0.2.R -f   $(pwd)  -s $1.recode.vcf.csv -t $1_distance_df.csv  -o $1_class.csv      -u     $1_pheatmap.png  -e $1.tre  #做聚类热图并获取相关文件
Rscript ./tools/get_sd.R -f $1_class.csv -s phenotype -t  $(pwd) -o $1_outfile
Rscript ./tools/boxplot.R -f $1_class.csv -s $1_out_boxplot.png -t  $(pwd) -o $1_distribution.png
