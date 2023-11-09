# This is an R script that calculates statistics and creates a histogram plot

# Load necessary libraries (if not already installed)
# install.packages("ggplot2")
library(ggplot2)

# Sample dataset (replace with your own data)
data <- c(22, 18, 25, 30, 35, 28, 19, 21, 23, 27)

# Calculate mean and standard deviation
mean_value <- mean(data)
sd_value <- sd(data)

cat("Dataset Mean:", mean_value, "\n")
cat("Dataset Standard Deviation:", sd_value, "\n")

# Create a histogram plot
ggplot(data = data, aes(x = data)) +
  geom_histogram(binwidth = 2, fill = "blue", color = "black", alpha = 0.7) +
  labs(title = "Histogram of Sample Data", x = "Value", y = "Frequency")
