#### Preamble ####
# Purpose: Downloads and saves the data from cricketdata package
# Author: Siddharth Gowda
# Date: 28 November 2024
# Contact: siddharth.gowda@mail.utoronto.ca
# License: MIT
# Pre-requisites: Install cricketdata R package and general understanding of
# the sport of cricket
# Any other information needed? None


#### Workspace setup ####
#install.packages("cricketdata", dependencies = TRUE)
library(cricketdata)
library(tidyverse)


#### Download data ####
ipl_bbb <- fetch_cricsheet("bbb", "male", "ipl")
ipl_bbb %>% glimpse()
ipl_bbb %>% head()
player_meta <- player_meta
player_meta %>% glimpse()
player_meta %>% head()


#### Save data ####
# [...UPDATE THIS...]
# change the_raw_data to whatever name you assigned when you downloaded it.
write_csv(ipl_bbb, "data/01-raw_data/ipl_men.csv")
write_csv(player_meta, "data/01-raw_data/player_meta.csv")

         
