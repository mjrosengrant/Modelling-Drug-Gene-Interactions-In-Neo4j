library(RNeo4j)
library(ggplot2)
neo4j = startGraph("http://localhost:7474/db/data")

drug_degrees = read.table("node_info/pc2_druggene/pc2_druggene_drug_degrees.csv",header=TRUE, sep=",")
drug_hist = hist(drug_degrees$degree)

gene_degrees = read.table("node_info/pc2_druggene/pc2_druggene_gene_degrees.csv",header=TRUE, sep=",")
hist(gene_degrees$degree)

modifier_degrees = read.table("node_info/pc2_druggene/pc2_druggene_modifier_degrees.csv",header=TRUE, sep=",")
hist(modifier_degrees$degree)

biomarker_degrees = read.table("node_info/pc2_druggene/pc2_druggene_biomarker_degrees.csv",header=TRUE, sep=",")
hist(biomarker_degrees$degree)

#biomarkerAndModifier_degrees = read.table("node_info/pc2_druggene/pc2_druggene_bio_mod_degrees.csv",header=TRUE, sep=",")
#hist(biomarkerAndModifier_degrees$degree)

allnode_degrees = read.table("node_info/pc2_druggene/pc2_druggene_allnode_degrees.csv",header=TRUE, sep=",")
hist(allnode_degrees$degree)

#Plots The connectivity CDF for the different types of nodes in our graph
xrange <- range(allnodes_degrees$degree) 
yrange <- range(allnodes_degrees$id) 

#Plots CDF of all node classifications
p <- ggplot()
p <- p + stat_ecdf(data=gene_degrees, aes(degree, color="Genes"))
p <- p + stat_ecdf(data=drug_degrees, aes(degree, color="Drugs"))
p <- p + stat_ecdf(data= biomarker_degrees, aes(degree, color="Biomarkers"))
p <- p + stat_ecdf(data= modifier_degrees, aes(degree,color="Modifiers"))
#p <- p + stat_ecdf(data= biomarkerAndModifier_degrees, aes(degree, color="Biomarkers+Modifiers"))
p <- p + ggtitle("CDF of Degree Values for Drug and Gene Nodes")
p <- p + ylab("Probability Density") 
p <- p + xlab("Degree")

print(p)

#KS Test
ks.test(gene_degrees$degree, modifier_degrees$degree)
ks.test(gene_degrees$degree, biomarker_degrees$degree)
ks.test(biomarker_degrees$degree, modifier_degrees$degree)



