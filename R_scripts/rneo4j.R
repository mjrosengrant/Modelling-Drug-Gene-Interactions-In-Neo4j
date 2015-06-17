library(RNeo4j)

graph = startGraph("http://localhost:7474/db/data")

results = getRels(graph, "Match (d:Drug {name:'AMG 337'})-[TARGETS]->(a:Aberration)<-[HAS_ABERRATION]-(g:Gene) RETURN HAS_ABERRATION")

rel = results[1]
print(typeof(results))


