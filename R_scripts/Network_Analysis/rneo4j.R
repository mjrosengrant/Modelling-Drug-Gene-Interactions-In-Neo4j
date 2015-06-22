library(RNeo4j)

neo4j = startGraph("http://localhost:7474/db/data")

nodes_query = "MATCH (g:Gene) RETURN ID(g) as id, g.symbol AS symbol"
edges_query="MATCH (g1:Gene)-[r]->(g2:Gene) RETURN DISTINCT g1.symbol AS source,TYPE(r) AS relType,g2.symbol AS target"

nodes = cypher(neo4j, nodes_query)
edges = cypher(neo4j, edges_query)

library(igraph)
#create igraph object
ig = graph.data.frame(edges, directed=TRUE, nodes)

#Run Girvan-Newman clustering algorithm
communities = edge.betweenness.community(ig)

#Extract cluster assignments and merge with nodes data.frame
memb = data.frame(name = communities$name, cluster=communities$membership)
nodes = merge(nodes,memb)

#Reorder columns
nodes = nodes[c("id", "symbol", "cluster")]

#convert nodes and edges to GraphJSON 
nodes_json = paste0("\"nodes\":", jsonlite::toJSON(nodes))
edges_json = paste0("\"edges\":", jsonlite::toJSON(edges))
all_json = paste0("{", nodes_json, ",", edges_json, "}")

sink(file = 'pc.json')
cat(all_json)
sink()




