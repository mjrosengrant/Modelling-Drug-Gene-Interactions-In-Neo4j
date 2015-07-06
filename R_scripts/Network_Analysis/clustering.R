library(RNeo4j)
#library(NetPathMiner)
neo4j = startGraph("http://localhost:7474/db/data")


#Gets all Gene and Drug Nodes from DB
nodes_query = "
MATCH n WHERE (n:Drug) or (n:Gene)
RETURN ID(n) AS id,
CASE 
WHEN n:Gene = True
THEN n.symbol
WHEN n:Drug = True
THEN n.name
End as name,
labels(n) AS label
Order by label[0]
"
#Returns list of edges between drugs and genes 
edges_query="MATCH (n:Drug)-[r:TARGETS_GENE]->(m:Gene) RETURN ID(n) AS source, ID(m) AS target"

#Returns number of connections each drug node has
drug_gene_connection_count = "MATCH (n:Drug)-[r]->(g:Gene) 
return n.name AS drug, count(r) AS connection_count ORDER BY -connection_count"

print("Finding Nodes...")
nodes = cypher(neo4j, nodes_query)
print("Finding Edges...")
edges = cypher(neo4j, edges_query)


library(igraph)
#create igraph object
ig = graph.data.frame(edges, directed=TRUE, nodes)

#http://www.inside-r.org/packages/cran/igraph/docs/transitivity
cc = transitivity(ig, vids=NULL, type="local")

print("Calculating Clustering Coefficients...")
print(cc)
#Run Girvan-Newman clustering algorithm
print("Running Girvan Newman betweenness algorithm")
communities = edge.betweenness.community(ig)

print ("Done calculating communities")
#Extract cluster assignments and merge with nodes data.frame
memb = data.frame(name = communities$name, cluster=communities$membership)
nodes = merge(nodes,memb)

#Reorder columns
nodes = nodes[c("id", "name", "label", "cluster")]

#print("New Nodes table with clustering:")
#print(nodes)

#convert nodes and edges to GraphJSON 
nodes_json = paste0("\"nodes\":", jsonlite::toJSON(nodes))
edges_json = paste0("\"edges\":", jsonlite::toJSON(edges))
all_json = paste0("{", nodes_json, ",", edges_json, "}")

sink(file = 'pc.json')
cat(all_json)
sink()


modifiers = cypher.execute(neo4j, "MATCH (d:Drug)-[r:TARGETS_GENE]->(g:Gene {entity_class:"modifier"}) return d.name AS drug_name, g.symbol AS gene_name")
