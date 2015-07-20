import pandas as pd 
import numpy as np

#Reads in the list of degree and betweenness outliers, and merges the 
#intersect of the lists into one file.
def main():
	degree_outliers = pd.read_csv('./degree_upper_outliers_10percent.csv')
	betweenness_outliers = pd.read_csv('./betweenness_upper_outliers_10percent.csv')

	intersect_list = degree_outliers.merge(betweenness_outliers)
	print intersect_list
	intersect_list.to_csv("d_b_intersects.csv")

main()