import csv
import numpy as np
from py2neo import Graph, Node, Relationship, authenticate
import urllib2

def writeFile(filename, nodeList, graph):
    with open(filename, 'a') as f:
        writer = csv.writer(f)            
        header = [ "id", "name", "degree" ]
        writer.writerows([header])
        for row in nodeList:
            is_part_of_rels =  graph.cypher.execute("MATCH (n)-[r:IS_PART_OF]->(rule:Rule) WHERE ID(n)={0} RETURN COUNT(r)".format(row["id"]) )

            #For accurate results, you need to subtract the [:IS_PART_OF] relationships from the degree total, since those are specific to our rulebase,
            #and don't provide any useful biological information
            row_degree = int (urllib2.urlopen("http://localhost:7474/db/data/node/{0}/degree/all".format(row["id"]) ).read()) - int(is_part_of_rels[0][0])
            new_row = [ row["id"], row["name"], row_degree ]
            writer.writerows([new_row])

def main():
    #Export results to CSV file
    authenticate("localhost:7474", "neo4j", "qwerty1")
    graph = Graph()
    
    #Run query to get list of all biomarker IDs
    biomarker_query = (
		"MATCH (n:Gene)-[:HAS_ABERRATION]->(a:Aberration {entity_class:'biomarker'}) " 
		"WHERE NOT( (n)-[:HAS_ABERRATION]->({entity_class:'modifier'} ) ) "
		"RETURN DISTINCT ID(n) as id, n.name as name order by name"
   		)
    #Run second query to get list of all modifier IDs
    modifier_query = (
		"MATCH (n:Gene)-[:HAS_ABERRATION]->(a:Aberration {entity_class:'modifier'}) " 
		"WHERE NOT( (n)-[:HAS_ABERRATION]->({entity_class:'biomarker'} ) ) "
		"RETURN DISTINCT ID(n) as id, n.name as name order by name"
   		)
    bio_mod_query = (
        "MATCH (n:Gene)-[:HAS_ABERRATION]->(a:Aberration {entity_class:'modifier'}) " 
        "WHERE ( (n)-[:HAS_ABERRATION]->({entity_class:'biomarker'} ) ) "
        "RETURN DISTINCT ID(n) as id, n.name as name order by name"
        )

    drug_query = "MATCH (d:Drug) RETURN DISTINCT ID(d) as id, d.name as name order by name"
    gene_query = "MATCH (g:Gene) RETURN DISTINCT ID(g) as id, g.name as name order by name"
    allNode_query = "MATCH n RETURN DISTINCT ID(n) as id, n.name as name order by name"
    aberration_query = "MATCH a RETURN DISTINCT ID(a) as id, a.name as name order by name"

    print "Executing Queries..."
    biomarkers = graph.cypher.execute(biomarker_query)
    modifiers = graph.cypher.execute(modifier_query)
    bio_mods = graph.cypher.execute(bio_mod_query)
    drugs = graph.cypher.execute(drug_query)
    genes = graph.cypher.execute(gene_query)
    allNodes = graph.cypher.execute(allNode_query)
    aberrations = graph.cypher.execute( aberration_query )

    #Make http request to neo4j to get degree for each.
    print "Writing to Files..."
    writeFile("pc2_biomarker_degrees.csv",biomarkers,graph)
    writeFile("pc2_modifier_degrees.csv",modifiers,graph)
    writeFile("pc2_bio_mod_degrees.csv",bio_mods,graph)
    writeFile("pc2_drug_degrees.csv",drugs,graph)
    writeFile("pc2_gene_degrees.csv",genes,graph)
    writeFile("pc2_allnode_degrees.csv",allNodes,graph)
    writeFile("pc2_aberration_degrees.csv",aberrations,graph)

    print "Done"



main()




