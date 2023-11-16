#!/usr/bin/Rscript
library("getopt")
spec <- matrix( c("first", "f", 2, "character", "This is first!",

"second", "s", 1, "character", "This is second!",

"third", "t", 2, "character", "This is third!",

"out","o",2,"character", "This is out!",

"plotout","u",2,"character","This is sumout!",

"treout","e",2,"character","This is sumout!",

"help", "h", 0, "logical", "This is Help!"),

byrow=TRUE, ncol=5) 
opt<-getopt(spec=spec)
print(opt$first)

library(pheatmap)
library(stringr)
library(ape)
#library(tidyverse)
library(ggtree)
library(tibble)

#读取文件
setwd(opt$first)
df3=read.csv(opt$second,header = T,sep=" ")
data1=t(df3)
colnames(data1)=data1[2,]
data1=data1[(-1:-2),]
#进行数据可读化转换
data1=gsub("A",'8',data1)
data1=gsub("T","6",data1)
data1=gsub("C","4",data1)
data1=gsub("G","2",data1)
data1=gsub("-","10",data1)
data1=gsub("N","12",data1)#anything else will be N
data2=as.data.frame(apply(data1,2,as.numeric))
rownames(data2)=paste(row.names(data1))
#进行层次聚类
dist_matrix=dist(data2)
hierarchical_result=
  hclust(dist_matrix,method = "complete")
tree=as.phylo(hierarchical_result)
distance_df <- as.data.frame(as.matrix(dist_matrix))
write.csv(distance_df,file=opt$third )
#进行分类处理，两种形式：根据类型分、根据距离分。
# 进行聚类并将聚类结果添加到数据框中
#threshold <- 25  # 你可以根据需要调整这个值
#cutree_result <- cutree(hierarchical_result, h = threshold)
num_clusters <- 4
cutree_result <- cutree(hierarchical_result, k = num_clusters)
heatmapdata=data2
data2$cluster <- as.factor(cutree_result)
cluster_variable_named <- as.data.frame(data2$cluster)
rownames(cluster_variable_named) <- paste(row.names(data2))
write.csv(cluster_variable_named,file = opt$out)
#p=pheatmap(heatmapdata,clustering_distance_rows = dist_matrix,clustering_method = "complete",cluster_cols =F,
#         show_rownames = F,show_colnames = F,annotation_row=cluster_variable_named)
a4_width_mm <- 210
a4_height_mm <- 297

# 将毫米转换为英寸（1英寸 = 25.4毫米）
a4_width_in <- a4_width_mm / 25.4
a4_height_in <- a4_height_mm / 25.4
png(opt$plotout,width = a4_width_in, height = a4_height_in, units = "in", res = 300)
p=pheatmap(heatmapdata,clustering_distance_rows = dist_matrix,clustering_method = "complete",cluster_cols =F,
         show_rownames = F,show_colnames = F,annotation_row=cluster_variable_named)
dev.off()
write.tree(tree,file = opt$treout)




