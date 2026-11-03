install.packages("cluster")


############################################################
# PROJECT 2: AIRLINE CUSTOMER SEGMENTATION
# R | Data Analytics | Machine Learning
#
# Business Objective:
# Segment airline loyalty customers based on mileage,
# travel activity, and reward behavior
# Method:
# K-Means Clustering with Silhouette Evaluation


# 1. LOAD LIBRARIES
library(cluster)
getwd()
# 2. LOAD DATA
airline <- read.csv("EastWestAirlines.csv",
                    check.names = TRUE)

cat("Total Customers:", nrow(airline), "\n")
cat("Total Variables:", ncol(airline), "\n")

str(airline)
summary(airline)

# 3. DATA QUALITY CHECK
cat("Missing Values:", sum(is.na(airline)), "\n")

# Remove identifiers
airline$Unnamed..0 <- NULL
airline$ID. <- NULL

# Store award status for business analysis
award_status <- airline$Award.
airline$Award. <- NULL

# 4. PREPARE FEATURES
# Log-transform nonnegative skewed numeric variables.
# Standardize all variables for distance-based clustering.

features <- airline

skewed_columns <- c(
  "Balance", "Qual_miles", "Bonus_miles",
  "Bonus_trans", "Flight_miles_12mo",
  "Flight_trans_12", "Days_since_enroll"
)

for (column in skewed_columns) {
  features[[column]] <- log1p(
    pmax(features[[column]], 0)
  )
}

scaled_data <- scale(features)

# 5. EVALUATE CLUSTERS
set.seed(1948)

cluster_options <- 2:7
silhouette_scores <- numeric(length(cluster_options))

# Sample customers for efficient silhouette evaluation
sample_ids <- sample(
  seq_len(nrow(scaled_data)),
  min(1000, nrow(scaled_data))
)

sample_dist <- dist(scaled_data[sample_ids, ])

for (i in seq_along(cluster_options)) {
  
  k <- cluster_options[i]
  
  model <- kmeans(
    scaled_data,
    centers = k,
    nstart = 25,
    iter.max = 100
  )
  
  sil <- silhouette(
    model$cluster[sample_ids],
    sample_dist
  )
  
  silhouette_scores[i] <- mean(sil[, 3])
}

selection_results <- data.frame(
  Clusters = cluster_options,
  Silhouette_Score = silhouette_scores
)

print(selection_results)

write.csv(
  selection_results,
  "k_selection_scores.csv",
  row.names = FALSE
)

# 6. SELECT BEST K
best_k <- cluster_options[
  which.max(silhouette_scores)
]

cat("\nSelected Number of Clusters:", best_k, "\n")

# 7. FINAL K-MEANS MODEL
set.seed(1948)

final_model <- kmeans(
  scaled_data,
  centers = best_k,
  nstart = 50,
  iter.max = 100
)

# Add segment labels to original data
results <- read.csv(
  "EastWestAirlines.csv",
  check.names = TRUE
)

results$Segment <- final_model$cluster

# 8. CUSTOMER SEGMENT ANALYSIS
segment_sizes <- as.data.frame(
  table(results$Segment)
)

names(segment_sizes) <- c(
  "Segment", "Customers"
)

print(segment_sizes)

# Calculate business metrics by segment
segment_summary <- aggregate(
  results[, c(
    "Balance",
    "Bonus_miles",
    "Bonus_trans",
    "Flight_miles_12mo",
    "Flight_trans_12",
    "Days_since_enroll",
    "Award."
  )],
  by = list(Segment = results$Segment),
  FUN = mean
)

segment_summary$Customers <- as.numeric(
  table(results$Segment)
)

print(segment_summary)

# 9. EXPORT RESULTS
write.csv(
  segment_summary,
  "segment_summary.csv",
  row.names = FALSE
)

write.csv(
  results,
  "customer_segments.csv",
  row.names = FALSE
)

# 10. VISUALIZATIONS
dir.create("visualizations", showWarnings = FALSE)

png("visualizations/silhouette_scores.png")
plot(
  cluster_options,
  silhouette_scores,
  type = "b",
  xlab = "Number of Clusters",
  ylab = "Average Silhouette Score",
  main = "Optimal Cluster Selection"
)
dev.off()

png("visualizations/segment_sizes.png")
barplot(
  segment_sizes$Customers,
  names.arg = segment_sizes$Segment,
  xlab = "Customer Segment",
  ylab = "Number of Customers",
  main = "Airline Customer Segments"
)
dev.off()

# PCA visualization
pca <- prcomp(scaled_data)

png("visualizations/customer_segments_pca.png")
plot(
  pca$x[, 1],
  pca$x[, 2],
  col = final_model$cluster,
  pch = 19,
  cex = 0.5,
  xlab = "Principal Component 1",
  ylab = "Principal Component 2",
  main = "Customer Segmentation Visualization"
)
dev.off()

# 11. COMPLETION MESSAGE
cat("\n====================================")
cat("\nAIRLINE SEGMENTATION COMPLETED!")
cat("\n====================================")
cat("\nSelected Clusters:", best_k)
cat("\nResults saved successfully.\n")
