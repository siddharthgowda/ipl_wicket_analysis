#### Preamble ####
# Purpose: Models... [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 11 February 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]


#### Workspace setup ####
library(tidyverse)
library(rstanarm)

#### Read data ####
set.seed(888)
cleaned_data <- read_parquet("data/02-analysis_data/cleaned_data.parquet")
# train data will be 80%, test will be 20%
index <- sample(1:nrow(cleaned_data), size = 0.8 * nrow(cleaned_data))
train_data <- cleaned_data[index, ]
test_data <- cleaned_data[-index, ]

### Model data ####
simple_glm_wicket_model <-
  glm(
    wicket ~ over,
    data = train_data,
    family = "binomial"
  )

complex_glm_wicket_model <-
  glm(
    wicket ~ over + prev_over_wickets,
    data = train_data,
    family = "binomial"
  )

overly_complex_glm_wicket_model <-
  glm(
    wicket ~ over + prev_over_wickets + batting_style + bowling_style,
    data = train_data,
    family = "binomial"
  )

#### Save test and train data ####
write_parquet(train_data, "data/02-analysis_data/train_data.parquet")
write_parquet(test_data, "data/02-analysis_data/test_data.parquet")

#### Save model ####
saveRDS(
  simple_glm_wicket_model,
  file = "models/simple_glm_wicket_model.rds"
)
saveRDS(
  complex_glm_wicket_model,
  file = "models/complex_glm_wicket_model.rds"
)
saveRDS(
  overly_complex_glm_wicket_model,
  file = "models/overly_complex_glm_wicket_model.rds"
)


