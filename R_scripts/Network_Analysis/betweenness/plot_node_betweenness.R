
#Plots The betweenness CDF for the different types of nodes in our graph
library(ggplot2)
p <- ggplot(biomarker_betweenness, aes(betweenness, color="Biomarkers", label = "Biomarkers")) + stat_ecdf()
p <- p + stat_ecdf(data=modifier_betweenness, aes(betweenness, color="Modiifers"))
p <- p + stat_ecdf(data=gene_betweenness, aes(betweenness, color="Genes"))
p <- p + stat_ecdf(data=drug_betweenness, aes(betweenness, color="Drugs"))
p <- p + stat_ecdf(data=allnodes_betweenness, aes(betweenness, color="All Nodes"))

print(p)