library(RNeo4j)

neo4j = startGraph("http://localhost:7474/db/data")

nodes_query = "
MATCH (a:Person)-[:ACTED_IN]->(:Movie)
RETURN DISTINCT ID(a) AS id, a.name AS name
"

edges_query = "
MATCH (a1:Person)-[:ACTED_IN]->(:Movie)<-[:ACTED_IN]-(a2:Person)
RETURN ID(a1) AS source, ID(a2) AS target
"

nodes = cypher(neo4j, nodes_query)
edges = cypher(neo4j, edges_query)

library(igraph)
#create igraph object
ig = graph.data.frame(edges, directed=FALSE, nodes)

#Run Girvan-Newman clustering algorithm
communities = edge.betweenness.community(ig)

#Extract cluster assignments and merge with nodes data.frame
memb = data.frame(name = communities$name, cluster=communities$membership)
nodes = merge(nodes,memb)

#Reorder columns
nodes = nodes[c("id", "name", "cluster")]

#convert nodes and edges to GraphJSON 
nodes_json = paste0("\"nodes\":", jsonlite::toJSON(nodes))
edges_json = paste0("\"edges\":", jsonlite::toJSON(edges))
all_json = paste0("{", nodes_json, ",", edges_json, "}")

sink(file = 'actors.json')
cat(all_json)
sink()




