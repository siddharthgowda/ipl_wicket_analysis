#### Preamble ####
# Purpose: Tests the structure and validity of the clean IPL data for
# tournaments 2021 to 2024
# Author: Siddharth Gowda
# Date: 26 November 2024
# Contact: siddharth.gowda@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - The `tidyverse` package must be installed
# - testthat must be installed
# - arrow must be installed
# - 04-test_analysis_data.R must have been run
# Any other information needed? None


#### Workspace setup ####
library(tidyverse)
library(testthat)
library(arrow)
analysis_data <- read_parquet("data/02-analysis_data/cleaned_data.parquet")

# Test if the data was successfully loaded
if (exists("analysis_data")) {
  message("Test Passed: The dataset was successfully loaded.")
} else {
  stop("Test Failed: The dataset could not be loaded.")
}

# all overs have values from 1-20
test_that("Overs are only in T20 range (1-20)", {
  expect_true(all(analysis_data$over %in% c(1:20)),
              info = "There are over numbers beyond 1 to 20, ensure that all data represents T20 cricket"
  )
})

# Battsmen are never the same as bowler
test_that("Bowlers are never bowling to themselves", {
  expect_true(all(analysis_data$bowler != analysis_data$striker),
              info = "The bowler cannot be the same person as the batter"
  )
})

# Test that bowling and batting teams ar e the same
test_that("The batting and bowling team is not the same", {
  expect_true(all(analysis_data$batting_team != analysis_data$bowling_team),
              info = "There is at least one instance of the bowling team being the same as the batting team"
  )
})

# Test wicket value is never na
test_that("Wicket Taken value is never NA", {
  expect_true(all(!is.na(analysis_data$wicket)),
              info = "There is at least one instance of the wicket taken value being NA"
  )
})

# Test wicket value is boolean
test_that("Wicket Taken value is always TRUE of FALSE", {
  expect_true(all(is_bare_logical(analysis_data$wicket)),
              info = "There is at least one instance of the wicket taken value being TRUE or FALSE"
  )
})