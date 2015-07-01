library(igraph)
library(RNeo4j)

neo4j = startGraph("http://localhost:7474/db/data")

getGraphQuery = "MATCH (n) OPTIONAL MATCH (n)-[r]-() Return n,r"

#Gets all Gene and Drug Nodes from DB
nodes_query = "
MATCH n
RETURN ID(n) AS id,
CASE 
WHEN n:Gene = True
THEN n.symbol
WHEN n:Drug = True
THEN n.name
End as name,
labels(n) AS label
Order by label[0]"

#Returns list of edges between drugs and genes 
edges_query=
"MATCH (n)-[r]-(m:Gene)
RETURN ID(n) AS source, ID(m) AS target"

print("Finding Nodes...")
nodes = cypher(neo4j, nodes_query)
print("Finding Edges...")
edges = cypher(neo4j, edges_query)

ig = graph.data.frame(edges, directed=TRUE, nodes)

print("Calculating betweeness")
results = betweenness(ig,directed= TRUE)
print(results)


