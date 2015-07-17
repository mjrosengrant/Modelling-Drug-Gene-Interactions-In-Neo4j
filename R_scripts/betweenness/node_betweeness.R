library(igraph)
library(RNeo4j)
library(plyr)
neo4j = startGraph("http://localhost:7474/db/data")


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

#This file contains betweenness of all nodes
#To get each class of node's betweenness, load this into the betweeness python script
#to split into separate CSVs for drugs,biomarkers, etc. 
write.csv(x= betweenness_results ,file="pc2_druggene_betweenness.csv")





