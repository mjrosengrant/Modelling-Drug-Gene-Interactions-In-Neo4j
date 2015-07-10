library(RNeo4j)
library(ggplot2)
neo4j = startGraph("http://localhost:7474/db/data")


drug_degrees = read.table("degrees/pc2_drug_degrees.csv",header=TRUE, sep=",")
hist(drug_degrees$degree)

gene_degrees = read.table("degrees/pc2_gene_degrees.csv",header=TRUE, sep=",")
hist(gene_degrees$degree)

modifier_degrees = read.table("degrees/pc2_modifier_degrees.csv",header=TRUE, sep=",")
hist(modifier_degrees$degree)

biomarker_degrees = read.table("degrees/pc2_biomarker_degrees.csv",header=TRUE, sep=",")
hist(biomarker_degrees$degree)

biomarkerAndModifier_degrees = read.table("degrees/pc2_bio_mod_degrees.csv",header=TRUE, sep=",")
hist(biomarkerAndModifier_degrees$degree)

allnode_degrees = read.table("degrees/pc2_allnode_degrees.csv",header=TRUE, sep=",")
hist(allnode_degrees$degree)


