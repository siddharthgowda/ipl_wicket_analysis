#### Preamble ####
# Purpose: Cleans the raw ipl and player data to only include ipl players and boundary deliveries
# Author: Siddharth Gowda
# Date: 28 November 2024
# Contact: siddharth.gowda@mail.utoronto.ca
# License: MIT
# Pre-requisites: tidyverse, lubridate, arrow packages must be installed,
# - 02-download_data.R must have been run
# Any other information needed? None

#### Workspace setup ####
library(tidyverse)
library(lubridate)
library(arrow)

#### Clean data ####
ipl_men_raw <- read_csv("data/01-raw_data/ipl_men.csv")
player_meta_raw <- read_csv("data/01-raw_data/player_meta.csv")
ipl_men_raw %>% glimpse()
player_meta_raw %>% glimpse()

ipl_men_clean <- ipl_men_raw %>%  mutate(year = year(ymd(start_date))) %>%
  select(!season) %>% select(!start_date) %>%
  mutate(run_rate = 6*(runs_scored_yet)/(120-balls_remaining)) %>% 
  select(match_id, year, venue, innings, over, ball, batting_team, bowling_team, 
         striker, bowler, runs_off_bat, wickets_lost_yet, wicket, target, run_rate) %>% 
  filter(run_rate != Inf) %>% filter(!is.na(run_rate)) %>% filter(year >= 2021)

ipl_men_clean_no_two_innings <- ipl_men_clean %>% filter(innings > 2)

ipl_men_clean <- ipl_men_clean %>% 
  filter(!(match_id %in% ipl_men_clean_no_two_innings$match_id))

player_meta_clean <- player_meta_raw %>% select(unique_name, batting_style, bowling_style, playing_role)

cleaned_data <- left_join(ipl_men_clean, player_meta_clean, by=c('striker' = 'unique_name')) %>% 
  select(!bowling_style) %>% rename(batter_playing_role = playing_role)

cleaned_data <- left_join(cleaned_data, (player_meta_clean %>% select(!batting_style)), 
                          by=c('bowler' = 'unique_name')) %>% 
  rename(bowler_playing_role = playing_role)

# Calculate recent wickets
recent_wickets <- cleaned_data %>%
  group_by(match_id, over, innings) %>%
  summarise(num_wickets = sum(wicket == TRUE), .groups = 'drop')

cleaned_data <- cleaned_data %>%
  left_join(recent_wickets, by = c("match_id", "innings", "over")) %>%
  # sorting data to use lag
  arrange(match_id, innings, over) %>%
  group_by(match_id, innings) %>%
  mutate(prev_over_wickets = lag(num_wickets)) %>%
  ungroup() %>%
  select(-num_wickets)

# remove na and for bowling_style removing bowlers who were listed to have
# multiple styles since there were very few of them and it makes the
# analysis messy

cleaned_data <- cleaned_data %>%
  filter(!is.na(bowler_playing_role)) %>%
  filter(!is.na(batter_playing_role)) %>%
  filter(!is.na(batting_style)) %>%
  filter(!is.na(bowling_style)) %>%
  filter(!grepl(",", bowling_style)) %>% 
  filter(!is.na(prev_over_wickets))


#### Save data ####
write_parquet(cleaned_data, "data/02-analysis_data/cleaned_data.parquet")