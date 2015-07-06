#Plots The connectivity CDF for the different types of nodes in our graph
xrange <- range(allnodes_degrees$degree) 
yrange <- range(allnodes_degrees$id) 

p <- ggplot(allnodes_degrees, aes(degree, color="All Nodes", label = "All Nodes")) + stat_ecdf()
p <- p + stat_ecdf(data=gene_degrees, aes(degree, color="Genes"))
p <- p + stat_ecdf(data=drugToGene_degrees, aes(degree, color="Drugs"))
p <- p + stat_ecdf(data=biomarker_degrees, aes(degree, color="Biomarkers"))
p <- p + stat_ecdf(data=modifier_degrees, aes(degree,color="Modifiers"))

print(p)

