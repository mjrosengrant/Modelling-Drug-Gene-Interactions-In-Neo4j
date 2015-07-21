library(extremevalues)
node_data <- read.table("node_info/pc2_druggene_info.csv",header=TRUE, sep=",")

#Returns List of outliers from dataframe x
discretize_ccle <- function(x, FLim = c(y,z)) {
  x_na_rm <- x[!is.na(x)]
  # x_na_rm <- x
  
  x_o <- getOutliers(x_na_rm, FLim = FLim, method ="II")
  
  outlier_limit <- c(max(x_na_rm[x_o$iLeft]), min(x_na_rm[x_o$iRight]))
  
  y <- x
  y[x <= outlier_limit[1]] = -1
  y[x >= outlier_limit[2]] = 1
  y[outlier_limit[1] < x & x < outlier_limit[2]] = 0
  
  x_o$discrete <- y
  x_o$outlier_limit = outlier_limit
  
  x_o
}

degree_outliers <- discretize_ccle(node_data$degree,FLim = c(.1, .9))
betweenness_outliers <- discretize_ccle(node_data$betweenness,FLim = c(.1, .9))

upper_degree_outliers <-  node_data[degree_outliers$discrete==1,]
lower_degree_outliers <-  node_data[degree_outliers$discrete==-1,]

upper_betweenness_outliers <-  node_data[betweenness_outliers$discrete==1,]
lower_betweenness_outliers <-  node_data[betweenness_outliers$discrete==-1,]

write.table(upper_degree_outliers,file="degree_upper_outliers_10percent.csv",sep = ",")
write.table(lower_degree_outliers,file="degree_lower_outliers.csv",sep = ",")

write.table(upper_betweenness_outliers,file="betweenness_upper_outliers_10percent.csv",sep = ",")
write.table(lower_betweenness_outliers,file="betweenness_lower_outliers.csv",sep = ",")

print(outliers)


