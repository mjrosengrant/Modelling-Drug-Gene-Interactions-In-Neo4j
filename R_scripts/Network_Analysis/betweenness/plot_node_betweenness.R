
#Plots The betweenness CDF for the different types of nodes in our graph
library(ggplot2)
p <- ggplot(allnodes_betweenness, aes(betweenness, color="All Nodes", label = "All Nodes")) + stat_ecdf()
#p <- p + stat_ecdf(data=modifier_betweenness, aes(betweenness, color="Modiifers"))
#p <- p + stat_ecdf(data=gene_betweenness, aes(betweenness, color="Genes"))
#p <- p + stat_ecdf(data=drug_betweenness, aes(betweenness, color="Drugs"))
#p <- p + stat_ecdf(data=biomarker_betweenness, aes(betweenness, color="Biomarkers"))

print(p)