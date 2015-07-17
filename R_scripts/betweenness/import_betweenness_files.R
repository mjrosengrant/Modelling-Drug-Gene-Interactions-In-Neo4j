
library(gdata)

allnodes_betweenness = read.table("node_info/pc2_druggene/pc2_druggene_allnode_info.csv",header = TRUE,sep=",")
hist(allnodes_betweenness$betweenness)

biomarker_betweenness = read.table("node_info/pc2_druggene/pc2_druggene_biomarker_betweenness.csv",header = TRUE,sep=",")
hist(biomarker_betweenness$betweenness)

modifier_betweenness = read.table("node_info/pc2_druggene/pc2_druggene_modifier_betweenness.csv",header=TRUE, sep=",")
hist(modifier_betweenness$betweenness)

gene_betweenness = read.table("node_info/pc2_druggene/pc2_druggene_gene_betweenness.csv",header=TRUE, sep=",")
hist(gene_betweenness$betweenness)

drug_betweenness = read.table("node_info/pc2_druggene/pc2_druggene_drug_betweenness.csv",header=TRUE, sep=",")
hist(drug_betweenness$betweenness)

library(ggplot2)
#Plots CDF of all node classifications
p <- ggplot()
p <- p + stat_ecdf(data=gene_betweenness, aes(betweenness, color="Genes"))
p <- p + stat_ecdf(data=drug_betweenness, aes(betweenness, color="Drugs"))
p <- p + stat_ecdf(data= biomarker_betweenness, aes(betweenness, color="Biomarkers"))
p <- p + stat_ecdf(data= modifier_betweenness, aes(betweenness,color="Modifiers"))
p <- p + ggtitle("CDF of Betweenness Values for Drug and Gene Nodes")
p <- p + ylab("Probability Density") 
p <- p + xlab("Betweenness")
print(p)

ks.test(gene_betweenness$betweenness, modifier_betweenness$betweenness)
ks.test(gene_betweenness$betweenness, biomarker_betweenness$betweenness)
ks.test(biomarker_betweenness$betweenness, modifier_betweenness$betweenness)


