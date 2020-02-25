# Import data
hawks <- read.csv("hawks.csv")

# Remove irrelevant columns
hawks <- hawks[-c(1:7, 9, 10, 16:20)]

# Remove missing values
hawks <- na.omit(hawks)

# Create a features dataframe (no species)
hawks_features <- hawks
hawks_features$Species <- NULL


# Standardize values for each variable 
hawks_features$Wing <- scale(hawks_features$Wing)
hawks_features$Weight <- scale(hawks_features$Weight)
hawks_features$Culmen <- scale(hawks_features$Culmen)
hawks_features$Hallux <- scale(hawks_features$Hallux)
hawks_features$Tail <- scale(hawks_features$Tail)


# Set seed
set.seed(1000)

# K-means clustering, k = 3 (Using non-standardized variables)
results <- kmeans(hawks_features, 3)
hawks_clustered <- data.frame(hawks_features, cluster=factor(results$cluster))


# Add species back to dataframe
species <- hawks$Species 
hawks_clustered <- cbind(species, hawks_clustered)


# Cluster Count per species
hawks_split <- split(hawks_clustered, hawks_clustered$species)

RT <- hawks_split$RT
CH <- hawks_split$CH
SS <- hawks_split$SS

cluster_RT <- table(RT$cluster)
cluster_CH <- table(CH$cluster)
cluster_SS <- table(SS$cluster)

cluster_count <- cbind(cluster_RT, cluster_CH, cluster_SS)


# Cluster Visualization of dimensions: Weight, Wing Length and Culmen.
install.packages("plotly")

library(plotly)

p<-plot_ly(hawks_clustered, x= ~Weight, y= ~Wing, z= ~Culmen, type = "scatter3d",
        mode = "markers", color= ~cluster)%>%
  add_markers() %>%
  layout(scene = list(xaxis = list(title = 'Weight'),
                      yaxis = list(title = 'Wing Length'),
                      zaxis = list(title = 'Culmen Length')))
p
  

# Data retrevied from: https://vincentarelbundock.github.io/Rdatasets/datasets.html
# More info: https://vincentarelbundock.github.io/Rdatasets/doc/Stat2Data/Hawks.html