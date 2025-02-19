# Title: Data Analyses
# Author: Arwenn Evenstar Kummer
# Date created: 19/02/2025  

# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# For a more user-friendly version with justification and description of each step in the process, please refer to the quarto document uploaded to the same GitHub repository as this file (file name: Step by Step Analyses)
# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

# Preamble:
# The data set we will analyse involves analyzing the species and counts of trapped ants, across two different sites - Fynbos and Eucalyptus/Gum trees. The data set contains species counts, species names and quantitative soil surface data, collected using a quadrat placed over the area where each pitfall trap was placed. 


# Pre-analysis ----

## install packages ----
install.packages("tidyverse")
install.packages("readxl")

# load packages into R
library(tidyverse)
library(readxl)

# Data wrangling, cleaning and checking ----

quad.dat <- read.csv("quadrat_data_clean.csv")
view(quad.dat)

pitfall.dat <- read.csv("pitfall_data_clean.csv")
view(pitfall.dat)


# obtain structure of data sets - checking for valid variable types
str(quad.dat)
str(pitfall.dat)

# renaming column headings for quadrat data. 
colnames(quad.dat) <- c("site", "live.veg.pcover", "leaf.litter.pcover", "bare.ground.pcover", "rocks.stones.pcover")

## check for missing values ----
sum(is.na(quad.dat))
sum(is.na(pitfall.dat))

## check for duplicates ----
sum(duplicated(quad.dat))
sum(duplicated(pitfall.dat))

# Suggested analyses - Branch Point 1: ----

### total abundances per site----

# create a new column with the total abundance per site.

pitfall_total_abundance <- pitfall.dat %>%
  group_by(pitfall) %>%
  mutate(total_abundance = rowSums(across(everything())))

### total species richness per site ----

# createa new column with species richness per site. 

pitfall_species_richness <- pitfall.dat %>%
  group_by(pitfall) %>%
  mutate(species_richness = rowSums(across(everything()) > 0))

# combine abundance, species richness and original pitfall data into 1 data frame:
pitfall.dat <- pitfall.dat %>%
  left_join(pitfall_total_abundance) %>%
  left_join(pitfall_species_richness)

# generate a new column of factors for each site type: G for gum/eucalyptus, and F for fynbos. 

pitfall.dat <- pitfall.dat %>%
  mutate(site_type = case_when (
    str_detect(pitfall, "G") ~ "G",
    str_detect(pitfall, "F") ~ "F"
  ))

# check new variable site_type is a factor with 2 levels:
str(pitfall.dat)
pitfall.dat$site_type <- as.factor(pitfall.dat$site_type)

str(pitfall.dat) # site_type is now a factor



# Data Visualization: ----
# Now we are all set to create the plots. We will use the ggplot2 package from tidyverse as well for this.


## bar chart of total abundance per site ----
ggplot(pitfall.dat, aes(x = pitfall, y = total_abundance)) +
  geom_bar(stat = "identity") +
  labs(title = "Total Abundance of Ants per Site",
       x = "Site",
       y = "Total Abundance") +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

## boxplot of total abundance between sites:
ggplot(pitfall.dat, aes(x = site_type, y = total_abundance)) +
  geom_boxplot() +
  labs(title = "Total Abundance of Ants between Sites",
       x = "Site Type",
       y = "Total Abundance") +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

## bar chart of species richness per site ---
ggplot(pitfall.dat, aes(x = pitfall, y = species_richness)) +
  geom_bar(stat = "identity") +
  labs(title = "Species Richness per Site",
       x = "Site",
       y = "Species Richness") +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

## boxplot of species richness between sites: ----
ggplot(pitfall.dat, aes(x = site_type, y = species_richness)) +
  geom_boxplot() +
  labs(title = "Species Richness between Sites",
       x = "Site Type",
       y = "Species Richness") +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))



## Statistical Analyses ----

# compare total abundance of ants between the two site types.

t.test(total_abundance ~ site_type, data = pitfall.dat)

# Welch Two Sample t-test
# 
# data:  total_abundance by site_type
# t = 1.5525, df = 16.401, p-value = 0.1396
# alternative hypothesis: true difference in means between group F and group G is not equal to 0
# 95 percent confidence interval:
#   -7.889391 51.389391
# sample estimates:
#   mean in group F mean in group G 
# 38.5625         16.8125 

# p-value = 0.1396 (>0.05). Thus, we fail to reject the null hypothesis that there is no difference in the total abundance of ants between the two site types.

# determine if there's a relationship between site type and species richness.

chisq.test(pitfall.dat$species_richness, pitfall.dat$site_type)

# Pearson's Chi-squared test
# 
# data:  pitfall.dat$species_richness and pitfall.dat$site_type
# X-squared = 7.1909, df = 6, p-value = 0.3036

# p-value = 0.3036 (>0.05), thus, we fail to reject the null hypothesis that there is no relationship between the site type and the species richness.

# Assessing correlation between quadrat variables and species richness/total abundance ----

# separate the 4 columns of quadrat data from quad.dat into a new data frame:
quad_vars <- quad.dat %>%
  select(live.veg.pcover, leaf.litter.pcover, bare.ground.pcover, rocks.stones.pcover)

# combine quad_vars with the pitfall.dat
pitfall.quad.dat <- cbind(pitfall.dat, quad_vars)
 

# run correlation tests between quadrat variables and species richness:

cor.test(pitfall.quad.dat$live.veg.pcover, pitfall.quad.dat$species_richness)

cor.test(pitfall.quad.dat$leaf.litter.pcover, pitfall.quad.dat$species_richness)
 
cor.test(pitfall.quad.dat$bare.ground.pcover, pitfall.quad.dat$species_richness)

cor.test(pitfall.quad.dat$rocks.stones.pcover, pitfall.quad.dat$species_richness)
 

# run correlation tests between quadrat variables and total abundances:
 
cor.test(pitfall.quad.dat$live.veg.pcover, pitfall.quad.dat$total_abundance)
 
cor.test(pitfall.quad.dat$leaf.litter.pcover, pitfall.quad.dat$total_abundance)
 
cor.test(pitfall.quad.dat$bare.ground.pcover, pitfall.quad.dat$total_abundance)
 
cor.test(pitfall.quad.dat$rocks.stones.pcover, pitfall.quad.dat$total_abundance)

