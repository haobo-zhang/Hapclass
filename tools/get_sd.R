#!/usr/bin/Rscript
library("getopt")
spec <- matrix( c("first", "f", 2, "character", "This is first!",

"second", "s", 1, "character", "This is second!",

"third","t",2, "character", "This is third!",

"out","o",2, "character", "This is out!",

"help", "h", 0, "logical", "This is Help!"),

byrow=TRUE, ncol=5) 

opt<-getopt(spec=spec)
setwd(opt$third)
lb.tb=read.table(opt$first)
names(lb.tb)=c("sample","class")
lb.tb=lb.tb[-1,]
df.tb=read.table(opt$second)
names(df.tb)=c("gene","name","tpm")
sample.lb=read.csv("sample.csv")
merged_tb <- merge(lb.tb, sample.lb, by = "sample")
merged_lb=merge(merged_tb,df.tb,by="name")
aov_result <- aov(tpm ~ class, data=merged_lb)
cleaned_aov_result <- na.omit(aov_result)
summary(cleaned_aov_result)
p_value <- summary(cleaned_aov_result)[[1]]$`Pr(>F)`
print(p_value)
outfile=paste(opt$first,opt$second,p_value,sep = ",")
if (any(!is.na(p_value) & p_value < 0.05)) {
  write.table(outfile, file = opt$out, sep = "\t", row.names = FALSE)
  print("P value is less than 0.05. output file generated.")
} else {
  print("P value is not less than 0.05. No output file generated.")
}



