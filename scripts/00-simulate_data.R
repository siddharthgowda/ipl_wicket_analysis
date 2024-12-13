#### Preamble ####
# Purpose: Simulates a dataset of IPL play by play data from 2021 to 2024
# Author: Siddharth Gowda
# Date: 28 November 2024
# Contact: siddharth.gowda@mail.utoronto.ca
# License: MIT
# Pre-requisites: The `tidyverse` and `arrow` packages must be installed
# Any other information needed? None

#### Workspace setup ####
library(tidyverse)
library(arrow)
set.seed(888)

#### Simulate data ####
venues <- c(
  "MA Chidambaram Stadium", "Wankhede Stadium", "Narendra Modi Stadium",
  "Arun Jaitley Stadium", "Zayed Cricket Stadium", "Sharjah Cricket Stadium",
  "Dubai International Cricket Stadium", "Brabourne Stadium",
  "Dr DY Patil Sports Academy", "Maharashtra Cricket Association Stadium",
  "Eden Gardens", "Punjab Cricket Association IS Bindra Stadium",
  "Bharat Ratna Shri Atal Bihari Vajpayee Ekana Cricket Stadium",
  "Rajiv Gandhi International Stadium, Uppal", "M Chinnaswamy Stadium",
  "Barsapara Cricket Stadium", "Sawai Mansingh Stadium",
  "Himachal Pradesh Cricket Association Stadium",
  "Maharaja Yadavindra Singh International Cricket Stadium",
  "Dr. Y.S. Rajasekhara Reddy ACA-VDCA Cricket Stadium"
)

teams <- c(
  "Mumbai Indians", "Royal Challengers Bangalore", 
  "Chennai Super Kings", "Delhi Capitals", 
  "Kolkata Knight Riders", "Sunrisers Hyderabad", 
  "Punjab Kings", "Rajasthan Royals", 
  "Lucknow Super Giants", "Gujarat Titans"
)

batters <- c("Rohit Sharma", "Ishan Kishan", "Suryakumar Yadav", 
             "Harry Brook", "Travis Head", "Nitish Rana", 
             "Jason Roy", "Rovman Powell", "Steve Smith", 
             "Tim David")

bowlers <- c("Jasprit Bumrah", "Mitchell Starc", 
             "Rashid Khan", "Varun Chakaravarthy", 
             "Mohammed Shami", "Yuzvendra Chahal")

bowling_style <- c("Right Arm Fast", "Left Arm Fast", 
                   "Right Arm Medium Pace","Left Arm Medium Pace",
                   "Right Arm Leg Spin","Left Arm Leg Spin")

n = 250
sim_data <- tibble(
  year = sample(2021:2024, size = n, replace = TRUE),
  venue = sample(venues, size = n, replace = TRUE),
  over = sample(1:20, size = n, replace = TRUE),
  balls = sample(1:6, size = n, replace = TRUE), # Removed extra comma here
  innings = sample(1:2, size = n, replace = TRUE),
  batting_team = sample(teams, size = n, replace = TRUE),
  bowling_team = sample(teams, size = n, replace = TRUE),
  wickets_lost_yet = sample(0:9, size = n, replace = TRUE),
  target = round(rnorm(n, mean = 180, sd = 40)),
  run_rate = round(rnorm(n, mean = 8, sd = 1), 2),
  bowler = sample(bowlers, size = n, replace = TRUE),
  bowler_role = sample(c("bowler", "all-rounder"), size = n, replace = TRUE),
  bowling_style = sample(bowling_style, size = n, replace = TRUE),
  batting_style = sample(c("left hand", "right hand"), size = n, replace = TRUE)
)

# Casing for runs and batters based on if bowlers or batters are selected for bowling and based on number of wickets
sim_data <- sim_data %>%
  mutate(
    striker = if_else(wickets_lost_yet > 7,
                      sample(bowlers, n(), replace = TRUE),
                      sample(batters, n(), replace = TRUE)),
    
    runs_scored = if_else(striker %in% batters,
                          pmax(round(rnorm(n(), mean = 3, sd = 1)), 0),
                          pmax(round(rnorm(n(), mean = 2, sd = 1.5)), 0)),
    
    wicket_taken = if_else(striker %in% bowlers,
                           rbinom(n(), size=1, prob=0.1),
                           rbinom(n(), size=1, prob=0.05)),
    
    batting_role = if_else(striker %in% bowlers,
                           sample(c("bowler", "all-rounder"), n(), replace = TRUE),
                           sample(c("top-order battsman", "mid-order battsman", "all-rounder"), 
                                  n(), replace = TRUE)),
                           
  ) %>% mutate(wicket_taken = wicket_taken == 1)

sim_data <- sim_data %>%
  filter(bowler != striker) %>%
  filter(batting_team != bowling_team) %>% 
  mutate(runs_scored = if_else(wicket_taken, 0, runs_scored))

#### Save data ####
write_parquet(sim_data, "data/00-simulated_data/simulated_data.parquet")