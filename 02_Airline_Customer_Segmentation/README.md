# Airline Customer Segmentation Using K-Means Clustering

**Tools:** R, RStudio, K-Means Clustering, Customer Analytics, Data Visualization

## Business Problem

Airline loyalty programs serve customers with different travel frequencies, mileage balances, and reward-earning behaviors. A single marketing strategy may not effectively address all customer groups.

**Objective:** Segment airline loyalty customers based on their travel and rewards activity to identify opportunities for targeted marketing, customer engagement, and retention.

## Dataset

The EastWest Airlines dataset contains **3,999 customer records** and 13 original variables covering:

- Mileage balances and qualifying miles
- Credit card bonus activity
- Flight miles and transactions
- Loyalty program enrollment duration
- Reward award status

## Methodology

1. Inspected the data for missing values and excluded customer identifiers.
2. Applied log transformations to selected numeric variables and standardized features.
3. Performed K-Means clustering, evaluating 2–7 clusters.
4. Compared clustering solutions using average silhouette scores.
5. Selected six clusters and profiled them using customer activity, mileage, tenure, and award behavior.

## Clustering Results

**Selected clusters:** 6  
**Highest sampled silhouette score:** 0.2565

| Segment | Customers | Characteristics |
|---|---:|---|
| 1 | 960 | High recent flight activity and mileage balances |
| 2 | 784 | Long-tenured customers with limited recent flying |
| 3 | 498 | Very low bonus and flight activity |
| 4 | 888 | High bonus-mile accumulation but little recent flying |
| 5 | 15 | Exceptionally high bonus-mile earners |
| 6 | 854 | Relatively newer members with lower balances and activity |

## Key Business Insights

- **Segment 1:** Potential audience for loyalty recognition and premium travel offers.
- **Segment 2:** Potential target for re-engagement campaigns.
- **Segment 3:** May benefit from introductory loyalty education and activation campaigns.
- **Segment 4:** Potential opportunity for converting reward engagement into flight activity.
- **Segment 5:** Small, unusual segment requiring further investigation before designing a dedicated strategy.
- **Segment 6:** Potential audience for early-life-cycle engagement and mileage-building incentives.

These recommendations are hypotheses based on descriptive segment profiles, not experimentally validated marketing outcomes.

## Visualizations

### Cluster Selection

![Silhouette Scores](visualizations/silhouette_scores.png)

### Segment Sizes

![Segment Sizes](visualizations/segment_sizes.png)

### Customer Segments — PCA View

![Customer Segments](visualizations/customer_segments_pca.png)

## Project Files

- [R Analysis Code](Airline_Customer_Segmentation.R)
- [Original Dataset](EastWestAirlines.csv)
- [Customer Segment Summary](segment_summary.csv)
- [Cluster Evaluation Scores](k_selection_scores.csv)
- [Customer Segment Assignments](customer_segments.csv)

## Limitations

The selected six-cluster solution achieved the highest sampled silhouette score among the configurations tested, but the score of approximately 0.257 indicates weak-to-moderate cluster separation. One segment contains only 15 customers and may reflect unusual observations rather than a stable customer group.

Further investigation, stability testing, and business validation would be required before implementing targeted campaigns.

## Project Attribution

This analysis was developed as a portfolio reconstruction of an academic customer segmentation project using the EastWest Airlines dataset. The documented clustering workflow and results reflect the analysis executed for this repository.
