import pandas as pd 
import numpy as np


def main():
	degree_outliers = pd.read_csv('./degree_upper_outliers_10percent.csv')
	betweenness_outliers = pd.read_csv('./degree_upper_outliers_10percent.csv')

	#intersect_list = pd.Series(list(set(degree_outliers["name"]).intersection(set(betweenness_outliers["name"]))))
	#intersect_list = pd.merge(degree_outliers, betweenness_outliers, how='inner', on=['name'])
	intersect_list = degree_outliers.merge(betweenness_outliers)
	print intersect_list
	intersect_list.to_csv("d_b_intersects.csv")

main()