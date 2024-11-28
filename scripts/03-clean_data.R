#### Preamble ####
# Purpose: Cleans the raw ipl and player data to only include ipl players and boundary deliveries
# Author: Siddharth Gowda
# Date: 28 November 2024
# Contact: siddharth.gowda@mail.utoronto.ca
# License: MIT
# Pre-requisites: tidyverse, lubridate, arrow packages must be installed
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
  select(match_id, year, venue, innings, over, ball, batting_team, bowling_team, 
         striker, bowler, runs_off_bat, wickets_lost_yet, target)

ipl_men_clean_no_two_innings <- ipl_men_clean %>% filter(innings > 2)

ipl_men_clean <- ipl_men_clean %>% 
  filter(!(match_id %in% ipl_men_clean_no_two_innings$match_id)) %>%
  # only boundaries
  mutate(is_boundary = (runs_off_bat >= 4))

player_meta_clean <- player_meta_raw %>% select(unique_name, batting_style, bowling_style, playing_role)

cleaned_data <- left_join(ipl_men_clean, player_meta_clean, by=c('striker' = 'unique_name')) %>% 
  select(!bowling_style) %>% rename(batter_playing_role = playing_role)

cleaned_data <- left_join(cleaned_data, (player_meta_clean %>% select(!batting_style)), 
                          by=c('bowler' = 'unique_name')) %>% 
  rename(bowler_playing_role = playing_role)

cleaned_data <- cleaned_data %>%
  filter(!is.na(bowler_playing_role)) %>%
  filter(!is.na(batter_playing_role)) %>%
  filter(!is.na(batting_style)) %>%
  filter(!is.na(bowling_style)) %>%
  filter(!grepl(",", bowling_style))

#### Save data ####
write_parquet(cleaned_data, "data/02-analysis_data/cleaned_data.parquet")