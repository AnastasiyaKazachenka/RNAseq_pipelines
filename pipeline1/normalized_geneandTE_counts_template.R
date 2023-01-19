TE_counts <- read.csv("raw_TE.counts", sep="\t", stringsAsFactors=FALSE, skip=1, row.names=1)
names_to_change <- colnames(TE_counts)
names_to_change <- gsub("..bam.files.", "", names_to_change)
names_to_change <- gsub("_k20.bam", "", names_to_change)
colnames(TE_counts) <- names_to_change
TE_counts <- TE_counts[ ,6:ncol(TE_counts)]
TE_counts <- TE_counts[ , order(names(TE_counts))]
TE_counts <- TE_counts[ rowSums(TE_counts)!=0,]

gene_counts <- read.csv("raw_gene.counts", sep="\t", stringsAsFactors=FALSE, skip=1, row.names=1)
names_to_change <- colnames(gene_counts)
names_to_change <- gsub("..bam.files.", "", names_to_change)
names_to_change <- gsub("_k20.bam", "", names_to_change)
colnames(gene_counts) <- names_to_change
gene_counts <- gene_counts[ ,6:ncol(gene_counts)]
gene_counts <- gene_counts[ , order(names(gene_counts))]
gene_counts <- gene_counts[ rowSums(gene_counts)!=0,]

genes <- c(rownames(gene_counts))
for (x in 1:length(genes)) {
  genes[x] <- gsub("\\..*","",genes[x])
}

rownames(gene_counts) <- genes

coldata <- read.csv("annotation.csv", sep=",", header=TRUE, row.names=1, na.strings = "No")

library("DESeq2")
total_data <- rbind(TE_counts,gene_counts)
total_data <- total_data[,row.names(coldata)]
total_matrix <- as.matrix(total_data)

dds_total_1 <- DESeqDataSetFromMatrix(countData=total_matrix, colData=coldata, design=~1)
dds_total_1 <- estimateSizeFactors(dds_total_1)
dds_total_1 <- as.data.frame(counts(dds_total_1, normalized=TRUE))
dds_total_1 <- dds_total_1[ rowSums(dds_total_1)!=0,]

write.csv(dds_total_1,file="normalized_TEandgene_counts.csv")