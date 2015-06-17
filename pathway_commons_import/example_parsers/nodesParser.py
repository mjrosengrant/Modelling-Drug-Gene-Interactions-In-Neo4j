#!/usr/bin/env python
import sys
import datetime
import time
from pymongo import MongoClient
from bson.objectid import ObjectId

# setting up access to Timikin database
client = MongoClient()
db = client.testtimikin
collection = db.biomolecules

#Initialization variables
delimiter = '\t'

#Opens the linked TSV file
handle = open(sys.argv[1])

#Initializes new objects of the Biomolecules class; acts as a template for docs to be inserted to MongoDB
class Biomolecule(dict):
	def __init__(self, alias=None):
		dict.__init__(self)
		self['_id'] = ObjectId() 
		self["created_at"] = datetime.datetime.utcnow()
		self["updated_at"] = None
		self["deleted_at"] = None
		self["contributor"] = "timikin"
		self["source"] = "fda"
		self["internal"] = []
		self["external"] = []
		self["timikin_visibility"] = ["public"]
		if alias is not None:
			self["alias"] = alias

#gets the list of results for documents with a given alias (or other key). Used here mainly to check for duplicates or to check if a document from the input file is already in the database.
def getDocuments(value, key='alias'):
	collection.ensure_index(key)
	results = collection.find({key:value}) 
	return results

biomolecules = []
fields = []
ids = []

def mirror(datafile):
	global fields
	lineCounter = 0
	fields = datafile.readline().strip().split(delimiter) 
	for line in datafile:
		lineCounter+=1
		values = line.strip('\r\n').split(delimiter) 
		biomolecule = Biomolecule(values[0]) 
		matchingElems = getDocuments(values[0])
		if len(fields) != len(values):
			print("Error: ", len(fields), " fields with ", len(values), " values")
		elif not matchingElems.count():
			for i, field in enumerate(fields):
				biomolecule[field] = values[i]
			global biomolecules
			biomolecules.append(biomolecule)
		if lineCounter%1000 == 0:
			print("Processed", lineCounter, "lines")	

def main():
	mirror(handle)
	print("Created", len(biomolecules), "biomolecules.")
	if len(biomolecules):
		ids = collection.insert(biomolecules);
		print("Inserted", len(ids), "biomolecules.")
	else: 
		print("No new elements were found!")

#Program execution starts here
startTime = time.time()
main()
print time.time() - startTime, "seconds"

