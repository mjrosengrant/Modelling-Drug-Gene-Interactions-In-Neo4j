
library(gdata)

allnodes_betweenness = read.table("./pc2_allnodes_betweenness.csv",header = TRUE,sep=",")
hist(allnodes_betweenness$betweenness)


biomarker_betweenness = read.table("./pc2_biomarker_betweenness.csv",header = TRUE,sep=",")
hist(biomarker_betweenness$betweenness)

modifier_betweenness = read.table("pc2_modifier_betweenness.csv",header=TRUE, sep=",")
hist(modifier_betweenness$betweenness)

gene_betweenness = read.table("pc2_gene_betweenness.csv",header=TRUE, sep=",")
hist(gene_betweenness$betweenness)

drug_betweenness = read.table("pc2_drug_betweenness.csv",header=TRUE, sep=",")
hist(drug_betweenness$betweenness)