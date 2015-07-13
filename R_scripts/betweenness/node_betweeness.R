library(igraph)
library(RNeo4j)
library(plyr)
neo4j = startGraph("http://localhost:7474/db/data")


#############################
#This section creates the entire graph.

getAllNodesQuery = 
"MATCH n OPTIONAL MATCH (n)-[r]-()
RETURN DISTINCT 

ID(n) AS identifier,

CASE 
WHEN n:Drug = True
THEN n.name
WHEN n:Gene = True
THEN n.name
WHEN n:Aberration = True
THEN n.type + ' ' + n.value + ' on gene ' + n.gene_entrez  
End as Title,

CASE
WHEN n:Gene = True
THEN n.entity_class 
END AS entity_class,

LABELS(n) AS label 
ORDER by label[0]
"

getAllNodesQuery = "MATCH n OPTIONAL MATCH (n)-[r]-()
RETURN DISTINCT ID(n) AS id"

getAllRelsQuery = "MATCH (n)-[r]->(m) Return ID(n) AS source, ID(m) AS target"

print("Finding Nodes...")
all_nodes = cypher(neo4j,getAllNodesQuery)
print("Finding Edges...")
all_edges = cypher(neo4j, getAllRelsQuery)

full_ig = graph.data.frame(all_edges,directed=TRUE, vertices = all_nodes)
print("Calculating Betweenness...")
betweenness_results = betweenness(full_ig,directed= TRUE, normalized = TRUE)
#all_results_df <- ldply(all_results,data.frame)
#colnames(all_results_df) <- c("node_name", "betweenness")


#This file contains betweenness of all nodes
#To get each class of node's betweenness, load this into the betweeness python script
#to split into separate CSVs for drugs,biomarkers, etc. 
write.csv(x= all_nodes ,file="pc2_allnodes_list.csv")
write.csv(x= all_edges ,file="pc2_alledges_list.csv")
write.csv(x= betweenness_results ,file="pc2_betweenness_list.csv")

#Merge Betweenness



#p <- ggplot(all_results_df, aes(betweenness)) + stat_ecdf()
#print(p)




