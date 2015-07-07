library(RNeo4j)
library(ggplot2)
neo4j = startGraph("http://localhost:7474/db/data")

drug_degree_query = "MATCH (d:Drug)-[r]->() 
RETURN d.name AS drug, count(r) AS degree ORDER BY -degree"
drug_degrees = cypher(neo4j, drug_degree_query)

drugToGene_degree_query = "MATCH (d:Drug)-[r]->(g:Gene) 
RETURN d.name AS drug, count(r) AS degree ORDER BY -degree"
drugToGene_degrees = cypher(neo4j, drugToGene_degree_query)

gene_degree_query = "MATCH (g:Gene)-[r]-() 
RETURN g.name AS gene, count(r) AS degree ORDER BY -degree"
gene_degrees = cypher(neo4j, gene_degree_query)

modifier_degree_query = "MATCH (g:Gene {entity_class:'modifier'})-[r]-() 
RETURN g.name AS gene, count(r) AS degree ORDER BY -degree"
modifier_degrees = cypher(neo4j, modifier_degree_query)

biomarker_degree_query = "MATCH (g:Gene {entity_class:'biomarker'})-[r]-() 
RETURN g.name AS gene, count(r) AS degree ORDER BY -degree"
biomarker_degrees = cypher(neo4j, biomarker_degree_query)

allnodes_degree_query = 
"MATCH n OPTIONAL MATCH (n)-[r]-()
RETURN ID(n) AS id,
CASE 
WHEN n:Gene = True
THEN n.name
WHEN n:Drug = True
THEN n.name
WHEN n:Aberration = True
THEN n.type + ' ' + n.value + ' on gene ' + n.gene_entrez  
End as name,
LABELS(n) AS label,
COUNT(r) AS degree ORDER BY -degree"
allnodes_degrees = cypher(neo4j,allnodes_degree_query)


