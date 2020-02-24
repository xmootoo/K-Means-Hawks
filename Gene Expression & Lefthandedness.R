# Data contains 1 column for gene expression that is hypothesized to be positively correlated with
# left-handedness.The other column contains a self-report rating of participant lefthandedness from 1-8 (ordinal).

claridge <- read.csv("claridge.csv")

# Store independent and dependent variable
lefthand <- claridge$hand
GE <- claridge$dnan


# First row deleted; it is a repetition of participant #.
claridge$X <- NULL

# Check for missing values.
sum(is.na(claridge))


# Analysis
## Histogram
hist(GE)
hist(lefthand)


# Check for outliers
boxplot.stats(GE)
boxplot.stats(lefthand)


# Spearman Correlation chosen to minimize effect of outliers and to better fit ordinal data
Spearman_cor <- cor(GE, lefthand, method = "spearman")

# Correlational test for Spearman's ρ (significance)
Cor_test <- cor.test(GE, lefthand, method = "spearman", exact=F, 
                     conf.level = 0.95)



# Ordinal Logistic Regression method

# Convert to ordinal data
claridge2 <- claridge
claridge2$hand <- as.ordered(claridge2$hand)
 
# Ordinal Logistic Regresison
install.packages("MASS")
library(MASS)

olr_Model <- polr(hand ~ dnan, data = claridge2, Hess = TRUE)

summary(olr_Model)

# p-values
olr_table <- coef(summary(olr_Model))
p <- pnorm(abs(olr_table[, "t value"]), lower.tail = FALSE) * 2
olr_table <- cbind(olr_table, "p value" = p)

olr_table

# Data retrevied from: https://vincentarelbundock.github.io/Rdatasets/datasets.html
# 'claridge' dataset info: https://vincentarelbundock.github.io/Rdatasets/doc/boot/claridge.html
