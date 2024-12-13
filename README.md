# IPL Wicket Analysis Report

## Overview

The goal of this paper is to figure out which variables are the best at predicting a future wicket in T20 Cricket. This was achieved by analyzing play by play cricket data from the 2021, 2022, 2023, and 2024 IPL men's tournament data. Overall, the analysis found that the number of wickets in the previous over was the best predictor of future wickets. The paper also contains an idealized methodology for recording cricket data, a data dictionary for cleaned data, and a datasheet for raw data (this includes a raw data dictionary).

Please run all files in the `scripts` folder before running the `paper.qmd` file.

## File Structure

The repo is structured as:

- `data/00-simulated_data` contains a simulated dataset.
- `data/01-raw_data` contains the raw data as obtained from the `cricketdata` package.
-   `data/02-analysis_data` contains the cleaned data set that was constructed using the `tidyverse` package.
-   `other` contains details about LLM chat interactions, and sketches.
-   `paper` contains the files used to generate the paper, including the Quarto document and reference bibliography file, as well as the PDF of the paper. The appendix of this paper also includes a clean data dictionary, a raw data datasheet, and an idealized methodology for recording cricket data. 
-   `scripts` contains the R scripts used to simulate, download, clean data, and train the models, and test the simulated and cleaned data sets.


## Statement on LLM usage

ChatGPT-4 was used to generate some documentation for reference, code debugging, and very lightly used to edit human written text. The entire chat history is available in `other/llm_usage/usage.txt`.
