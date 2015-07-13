library(RNeo4j)
library(igraph)

neo4j = startGraph("http://localhost:7474/db/data")

#Gets all Gene and Drug Nodes from DB
nodes_query = 
"MATCH n OPTIONAL MATCH (n)-[r]-()
RETURN DISTINCT 

ID(n) AS id,

CASE 
WHEN n:Drug = True
THEN n.name
WHEN n:Gene = True
THEN n.name
WHEN n:Aberration = True
THEN n.type + ' ' + n.value + ' on gene ' + n.gene_entrez  
End as name,

CASE
WHEN n:Gene = True
THEN n.entity_class 
END AS entity_class,

LABELS(n) AS label 
ORDER by label[0]
"
#Returns list of edges between drugs and genes 
edges_query="MATCH (n)-->(m) RETURN ID(n) AS source, ID(m) AS target"

drugs_query = "MATCH (d:Drugs) return ID(d) AS id, d.name AS name"
drug_edges_query = "MATCH (d:Drugs)-->(n) return ID(d) as source, ID(n) as target
UNION MATCH (n)-->(d:Drugs) return ID(n) as source, ID(d) as target"

print("Finding Nodes...")
nodes = cypher(neo4j, nodes_query)
print("Finding Edges...")
edges = cypher(neo4j, edges_query)

nodes_df = do.call(rbind.data.frame, nodes)
edges_df = do.call(rbind.data.frame, edges)

#create igraph object
ig = graph.data.frame(edges_df, directed=TRUE, nodes_df)


#http://www.inside-r.org/packages/cran/igraph/docs/transitivity
#print("Calculating Clustering Coefficients...")
#cc = transitivity(ig, vids=NULL, type="local")

#table = merge(nodes,cc)

#print("Writing clustering coefficients to CSV...")
#write.table(table, file = "/node_info/allnodes_clustering.csv", append = FALSE, quote = TRUE, sep = ",",
 #           eol = ";", na = "NA", dec = ".",
  #          col.names = TRUE,
   #         fileEncoding = "utf-8")


#Run Girvan-Newman clustering algorithm
#print("Running Girvan Newman betweenness algorithm")
#communities = edge.betweenness.community(ig)

#print ("Done calculating communities")
#Extract cluster assignments and merge with nodes data.frame
#memb = data.frame(name = communities$name, cluster=communities$membership)
#nodes = merge(nodes,memb)

#Reorder columns
#nodes = nodes[c("id", "name", "label", "cluster")]


