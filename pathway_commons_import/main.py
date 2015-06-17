import pandas as pd 
import numpy as np
from py2neo import Graph, Node, Relationship, authenticate


def getAllGeneA(graph,data):
	uniqueGenes = np.unique(data["PARTICIPANT_A"])
	print uniqueGenes[0]
	print uniqueGenes[1]

	for i in range(uniqueGenes.size):
		query = "MERGE (g:Gene {{symbol:\"{0}\", added:'June16' }} )".format( uniqueGenes[i] )
		print query
		graph.cypher.execute(query)

def getAllGeneB(graph,data):
	uniqueGenes = np.unique(data["PARTICIPANT_B"])
	print uniqueGenes[0]
	print uniqueGenes[1]

	for i in range(uniqueGenes.size):
		query = "MERGE (g:Gene {{symbol:\"{0}\", added:'June16' }} )".format( uniqueGenes[i] )


def createRelationships(graph,data):
	for i in range(data["INTERACTION_TYPE"].size):
		query = "Match (ga:Gene {{symbol:\"{0}\", added:'June16' }}), (gb:Gene {{symbol:\"{1}\", added:'June16' }}) CREATE UNIQUE (ga)-[:{2} {{added:'June16'}}]->(gb)".format(data["PARTICIPANT_A"][i],data["PARTICIPANT_B"][i], data["INTERACTION_TYPE"][i].upper().replace("-","_"))

		print query
		graph.cypher.execute(query)


def getGeneA(data,row):
	return data["PARTICIPANT_A"][row]

def main():
	data = pd.read_csv('./PC.Reactome.EXTENDED_BINARY_SIF.hgnc.csv')
	
	authenticate("localhost:7474", "neo4j", "qwerty1")
	graph = Graph()

	#getAllGeneA(graph,data)
	#getAllGeneB(graph,data)
	createRelationships(graph,data)

	#for i in range(100):
	#	currGene = getGeneA(data,i)
	#	print currGene

main()
