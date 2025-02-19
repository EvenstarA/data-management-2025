# Title: Data Analyses
# Author: Arwenn Evenstar Kummer
# Date created: 19/02/2025  

# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# For a more user-friendly experience, read the quarto document uploaded to GitHub repository (title of quarto file)
# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

# Preamble:
# The data set we will analyse involves analyzing the species and counts of trapped ants, across two different sites - Fynbos and Eucalyptus/Gum trees. The data set contains species counts, species names and quantitative soil surface data, collected using a quadrat placed over the area where each pitfall trap was placed. 


# Pre-analysis work ----

## install packages ----
install.packages("tidyverse")
install.packages("readxl")

# load packages into R
library(tidyverse)
library(readxl)

# Data wrangling, cleaning and checking ----

# We have data on quadrat vegetation, species counts and species names. We will read in each data sheet, clean it and reorganize it for analysis.
quad.dat <- read.csv("quadrat_data_clean.csv")
view(quad.dat)

pitfall.dat <- read.csv("pitfall_data_clean.csv")
view(pitfall.dat)


# exploring the data structure - confirming that variables are the correct type (i.e. chr for site and pitfall tags, and int for the counts)
str(quad.dat)
str(pitfall.dat)

## check for missing values ----
sum(is.na(quad.dat))
sum(is.na(pitfall.dat))

## check for duplicates ----
sum(duplicated(quad.dat))
sum(duplicated(pitfall.dat))



