# Hapclass
用于快速进行材料的基因型分型

本次采用的层次聚类的算法对材料进行基因型分型。

```sh
cp -r /your/pathway/tools/ /your/workspace
cp tools/MakeHeatmap.sh .
sh MakeHeatmap.sh [yourvcffile]
#Note:我的vcf名为:A04_20875046_20875792.indel.M5M8.vcf.recode.vcf
#			我的命令为: sh MakeHeatmap.sh A04_20875046_20875792.indel.M5M8.vcf
```
