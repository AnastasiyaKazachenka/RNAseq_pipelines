setwd("./salmon082")
my_files <- list.dirs(path=".",recursive = FALSE)
sample_name <- c()
for (x in 1:length(my_files)) {
  sample_name<- c(sample_name,strsplit(my_files[x],"/")[[1]][2])
}

library(tximport)

my_files_quant <- paste(my_files[],"quant.sf",sep="/")
txi <- tximport(my_files_quant,type="salmon", txOut=TRUE)
cts1 <- as.data.frame(txi$abundance)
cts1 <- cts1[rowSums(cts1)>0,]
colnames(cts1) <- sample_name

write.csv(cts1, file="../TPMs_salmon082.csv")
