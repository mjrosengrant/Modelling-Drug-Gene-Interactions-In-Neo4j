#!/usr/bin/env python
import sys
import datetime
import time
from pymongo import MongoClient #Used for establishing mongo connection
from bson.objectid import ObjectId

client = MongoClient()
db = client.testtimikin
bCollection = db.biomolecules
iCollection = db.interactions

delimiter = '\t'
particpantACol = 0
particpantBCol = 2
step = 100000

handle = open(sys.argv[1])

class Interaction(dict):
	def __init__(self, alias=None):
		dict.__init__(self)
		self['_id'] = ObjectId()
		self["created_at"] = datetime.datetime.utcnow()
		self["updated_at"] = None
		self["deleted_at"] = None
		self["contributor"] = "timikin"
		self["source"] = "fda"
		self["timikin_visibility"] = ["public"]

# method for finding elements by alias or key/value pair
def find(value, key='alias'):
	bCollection.ensure_index(key)
	results = bCollection.find({key:value})
	count = results.count()
	if count == 0:
		print("Element not found: ", key, ":", value)
		return None
	elif count == 1:
		return results[0]
	else:
		if key is 'alias':
			for e in results:
				if e['alias'][0] == value: #ensures a single gene return
					return e;
	print("Element returned multiple results: ", key, ":", value)
	return None

def addExternal(biomolecule, interaction):
	if biomolecule is not None:
		biomolecule["external"].append(interaction["_id"])
		bCollection.save(biomolecule)

def addInternal(biomolecule, interaction):
	if biomolecule is not None:
		biomolecule["internal"].append(interaction["_id"])
		bCollection.save(biomolecule)

def getInteractions(interaction):
	interactionDict = {};
	for i, field in enumerate(fields):
		interactionDict[field] = interaction[field];
	results = iCollection.find(interactionDict);
	return results

interactions = []
def mirror(datafile):
	global fields
	lineCounter = 0
	fields = datafile.readline().strip().split(delimiter) 
	print "Processing..."
	for line in datafile:
		lineCounter += 1
		values = line.strip('\r\n').split(delimiter)
		interaction = Interaction(values[0]) 
		if len(fields) != len(values):
			print("Error: ", len(fields), " fields with ", len(values), " values")
		else:
			for i, field in enumerate(fields):
				interaction[field] = values[i];
			matchingElems = getInteractions(interaction)
			if not matchingElems.count():
				global interactions
				interactions.append(interaction)
		if lineCounter%10000 == 0:
			print("Processed", lineCounter, "lines")

def pushInteractions():
	print "Pushing interactions to database..."
	interactionsLength = len(interactions)
	interactionsDone = 0
	while interactionsLength-interactionsDone > step:
		ids = iCollection.insert(interactions[interactionsDone:interactionsDone+step]);
		interactionsDone += len(ids)
	ids = iCollection.insert(interactions[interactionsDone:]);
	interactionsDone += len(ids)
	return interactionsDone

def link():
	interactionsCounter = 0;
	for interaction in interactions:
		addExternal(find(interaction[fields[particpantACol]]),interaction)
		addInternal(find(interaction[fields[particpantBCol]]),interaction)
		interactionsCounter += 1
		if(interactionsCounter%10000):
			print("Processed", interactionsCounter, "lines") 

def main():
	mirror(handle)
	print("Created", len(interactions), "interactions.")
	if len(interactions):
		print("Inserted", pushInteractions(), "interactions.")
		link()
	else: 
		print("No new elements were found!")

#Program execution starts here
startTime = time.time()
main()
print time.time() - startTime, "seconds"