# coding: utf-8
# Pathway Commons Data can be found at http://www.pathwaycommons.org/pc2/downloads
# File to download from page above is PC.Reactome.EXTENDED_BINARY_SIF.hgnc

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

#Reads in Homo_sapiens.txt and creates a dictionary mapping GeneSymbols to their Entrez values
def createEntrezDict():
    homo_sapiens = pd.read_csv('node_info/pc_data/Homo_sapiens.txt',sep="\t")
    dictionary = pd.Series(homo_sapiens.GeneID.values, index=homo_sapiens.Symbol.values).to_dict()
    return dictionary


def createAllGenes(graph,data):
    #Create Dictionary that takes gene symbol as input and return entrez value
    entrezDict = createEntrezDict()

    uniqueGenes = np.unique(data[["PARTICIPANT_A","PARTICIPANT_B"]])
    for i in range(uniqueGenes.size):
        
        geneName = str(uniqueGenes[i])
        entrez = ""
        
        if geneName in entrezDict:
            entrez = str(entrezDict[geneName])
            
        query = "MERGE (g:Gene {{name:\"{0}\", entrez:\"{1}\"}} )".format( geneName, entrez)
        
        currentIsGene = isGene(geneName)
        if currentIsGene is True:
            print query +"\n"            
            graph.cypher.execute(query)
        else:
            print geneName + " is not a gene. Skipping"               


def createRelationships(graph,data):
    
    for i in range(data["INTERACTION_TYPE"].size):
        
        #Makes sure that the Interaction Type does not involve proteins or Molecules
        if (data["INTERACTION_TYPE"][i] == "SmallMoleculeReference" or 
                data["INTERACTION_TYPE"][i] == "ProteinReference"):
            print "Row {0} is a molecule interaction. Skipping".format(i)
            continue


        #Query looks for genes in graph, and creates a unique relationship between them. 
        query ="Match (ga:Gene {{name:\"{0}\" }}),(gb:Gene {{name:\"{1}\" }}) CREATE UNIQUE (ga)-[:{2} {{source:'Pathway Commons',data_source:\"{3}\", pubmed_id:\"{4}\", pathway_names:\"{5}\"}}]->(gb)".format(
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

def main():
    print "Starting Main Function"
    data = pd.read_csv('node_info/pc_data/PC.Reactome.EXTENDED_BINARY_SIF.hgnc.csv')

    authenticate("localhost:7474", "neo4j", "qwerty1")
    graph = Graph()

    createAllGenes(graph,data)
    createRelationships(graph,data)

main()
