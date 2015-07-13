library(RNeo4j)
library(ggplot2)
neo4j = startGraph("http://localhost:7474/db/data")

drug_degrees = read.table("node_info/pc2_drug_degrees.csv",header=TRUE, sep=",")
drug_hist = hist(drug_degrees$degree)
export()


gene_degrees = read.table("node_info/pc2_gene_degrees.csv",header=TRUE, sep=",")
hist(gene_degrees$degree)

modifier_degrees = read.table("node_info/pc2_modifier_degrees.csv",header=TRUE, sep=",")
hist(modifier_degrees$degree)

biomarker_degrees = read.table("node_info/pc2_biomarker_degrees.csv",header=TRUE, sep=",")
hist(biomarker_degrees$degree)

biomarkerAndModifier_degrees = read.table("node_info/pc2_bio_mod_degrees.csv",header=TRUE, sep=",")
hist(biomarkerAndModifier_degrees$degree)

allnode_degrees = read.table("node_info/pc2_allnodes_info.csv",header=TRUE, sep=",")
hist(allnode_degrees$degree)

#Plots The connectivity CDF for the different types of nodes in our graph
xrange <- range(allnodes_degrees$degree) 
yrange <- range(allnodes_degrees$id) 

#Plots CDF of all node classifications
p <- ggplot(allnode_degrees, aes(degree, color="All Nodes", label = "All Nodes")) + stat_ecdf()
p <- p + stat_ecdf(data=gene_degrees, aes(degree, color="Genes"))
p <- p + stat_ecdf(data=drug_degrees, aes(degree, color="Drugs"))
p <- p + stat_ecdf(data= biomarker_degrees, aes(degree, color="Biomarkers"))
p <- p + stat_ecdf(data= modifier_degrees, aes(degree,color="Modifiers"))
p <- p + stat_ecdf(data= biomarkerAndModifier_degrees, aes(degree, color="Biomarkers+Modifiers"))


print(p)


