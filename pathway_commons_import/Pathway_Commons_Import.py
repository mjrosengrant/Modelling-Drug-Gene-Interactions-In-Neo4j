
# coding: utf-8

# In[ ]:

import pandas as pd 
import numpy as np
from py2neo import Graph, Node, Relationship, authenticate

def isGene(potentialGene):
    if "KNOWLEDGEBASE" in str(potentialGene):
        return False
    #cells with semicolons have multiple genes listed, so it is easier to skip them
    if ";" in str(potentialGene):
        return False
    #Genes are all in upper case
    elif str(potentialGene).isupper():
        return True
    else:
        return False
    

def createAllGenes(graph,data):
    uniqueGenes = np.unique(data[["PARTICIPANT_A","PARTICIPANT_B"]])

    for i in range(uniqueGenes.size):
        #Check if value is actually a gene as opposed to a molecule
        
        currentIsGene = isGene(uniqueGenes[i])
        query = "MERGE (g:Gene {{symbol:\"{0}\" }} )".format( str(uniqueGenes[i]) )
        
        if currentIsGene is True:
            print query +"\n"            
            graph.cypher.execute(query)
        else:
            print str(uniqueGenes[i]) + " is not a gene. Skipping"               

def createRelationships(graph,data):
    
    for i in range(data["INTERACTION_TYPE"].size):
        
        #Makes sure that the Interaction Type does not involve proteins or Molecules
        if (data["INTERACTION_TYPE"][i] == "SmallMoleculeReference" or 
                data["INTERACTION_TYPE"][i] == "ProteinReference"):
            print "Row {0} is a molecule interaction. Skipping".format(i)
            continue
               
        #Query looks for genes in graph, and creates a unique relationship between them. 
        query ="Match (ga:Gene {{symbol:\"{0}\", added:'June17' }}),(gb:Gene {{symbol:\"{1}\", added:'June17' }}) CREATE UNIQUE (ga)-[:{2}{{added:'June17',data_source:\"{3}\", pubmed_id:\"{4}\", pathway_names:\"{5}\"}}]->(gb)".format(
            data["PARTICIPANT_A"][i],
            data["PARTICIPANT_B"][i], 
            data["INTERACTION_TYPE"][i].upper().replace("-","_"),
            data["INTERACTION_DATA_SOURCE"][i],
            data["INTERACTION_PUBMED_ID"][i],             
            data["PATHWAY_NAMES"][i]
            )
        
        if isGene(str(data["PARTICIPANT_A"][i])) and isGene(str(data["PARTICIPANT_B"][i])):
            print query + "\n"
            graph.cypher.execute(query)
        else:
            print "At least one of the participants is not a gene. Skipping row " + str(i)
            continue


def getGeneA(row):
    #Check if this row is a gene or a molecule
    isGeneVal = isGene(row["PARTICIPANT_A"])

def main():
    print "Starting Main Function"
    data = pd.read_csv('./pc_data/PC.Reactome.EXTENDED_BINARY_SIF.hgnc.csv')

    authenticate("localhost:7474", "neo4j", "qwerty1")
    graph = Graph()

    createAllGenes(graph,data)
    #createRelationships(graph,data)

    #for i in range(100):
        #current_row = data.iloc[i]
        #print current_row["INTERACTION_TYPE"]
        #currGene = getGeneA(current_row)
        #print currGene

main()


# In[ ]:



