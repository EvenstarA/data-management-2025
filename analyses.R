# Title: Data Analyses
# Author: Arwenn Evenstar Kummer
# Date created: 19/02/2025  

# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# For a more user-friendly version with justification and description of each step in the process, please refer to the quarto document uploaded to the same GitHub repository as this file (file name: Step by Step Analyses)
# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

# Preamble:
# The data set we will analyse involves analyzing the species and counts of pitfall trapped ants, across two different vegetation types - Fynbos and Eucalyptus/Gum trees. The data set contains species counts, species names and quantitative soil surface data, collected using a quadrat placed over the sample site where each pitfall trap was placed. 


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



# Suggested analyses (Branch Point 1 in GitHub log): ----

### total abundances per sample site/pitfall trap----

# create a new column with the total abundance per trap

pitfall_total_abundance <- pitfall.dat %>%
  group_by(pitfall) %>%
  mutate(total_abundance = rowSums(across(everything())))

### total species richness per sample site/pitfall trap ----

# create a new column with species richness per trap 

pitfall_species_richness <- pitfall.dat %>%
  group_by(pitfall) %>%
  mutate(species_richness = rowSums(across(everything()) > 0))

# combine abundance, species richness and original pitfall data into original data frame:
pitfall.dat <- pitfall.dat %>%
  left_join(pitfall_total_abundance) %>%
  left_join(pitfall_species_richness)

# generate a new column of factors for each vegetation type: G for gum/eucalyptus, and F for fynbos. 

pitfall.dat <- pitfall.dat %>%
  mutate(veg_type = case_when (
    str_detect(pitfall, "G") ~ "G",
    str_detect(pitfall, "F") ~ "F"
  ))

# check new variable site_type is a factor with 2 levels:
str(pitfall.dat)
pitfall.dat$veg_type <- as.factor(pitfall.dat$veg_type)
str(pitfall.dat) # site_type is now a factor



# Data Visualization: ----

## Total Abundance plots:----

# bar chart of total abundance per sample site/pitfall trap

ggplot(pitfall.dat, aes(x = pitfall, y = total_abundance)) +
  geom_bar(stat = "identity") +
  labs(title = "Total abundance (count) of ants per pitfall trap",
       x = "Pitfall trap",
       y = "Total abundance (count)") +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# boxplot of total abundance between vegetation types:
ggplot(pitfall.dat, aes(x = veg_type, y = total_abundance)) +
  geom_boxplot() +
  labs(title = "Total abundance of ants (count) between vegetation types",
       x = "Vegetation type",
       y = "Total Abundance (count)") +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

## Species richness plots: ----

# bar chart of species richness per sample site/pitfall trap 
ggplot(pitfall.dat, aes(x = pitfall, y = species_richness)) +
  geom_bar(stat = "identity") +
  labs(title = "Species richness per pitfall trap",
       x = "Pitfall trap",
       y = "Species Richness") +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# boxplot of species richness between vegetation types
ggplot(pitfall.dat, aes(x = veg_type, y = species_richness)) +
  geom_boxplot() +
  labs(title = "Species richness between vegetation types",
       x = "Vegetation type",
       y = "Species Richness") +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))



# Statistical Analyses ----

## Compare total abundance of ants between the two vegetation types ----

t.test(total_abundance ~ veg_type, data = pitfall.dat)

# p-value = 0.1396 (>0.05). Thus, we fail to reject the null hypothesis that there is no difference in the total abundance of ants between the two vegetation types.


## Determine if there's a relationship between site type and species richness ----

chisq.test(pitfall.dat$species_richness, pitfall.dat$veg_type)

# p-value = 0.3036 (>0.05), thus, we fail to reject the null hypothesis that there is no relationship between the vegetation type and the species richness.


## Assessing correlation between quadrat variables and species richness/total abundance ----

# separate the 4 columns of quadrat data from quad.dat into a new data frame:
quad_vars <- quad.dat %>%
  select(live.veg.pcover, leaf.litter.pcover, bare.ground.pcover, rocks.stones.pcover)

# combine quad_vars with the pitfall.dat
pitfall.quad.dat <- cbind(pitfall.dat, quad_vars)
 

# run correlation tests between quadrat variables and species richness: (could likely use a function but this is beyond my expertise)

cor.test(pitfall.quad.dat$live.veg.pcover, pitfall.quad.dat$species_richness)

cor.test(pitfall.quad.dat$leaf.litter.pcover, pitfall.quad.dat$species_richness)
 
cor.test(pitfall.quad.dat$bare.ground.pcover, pitfall.quad.dat$species_richness)

cor.test(pitfall.quad.dat$rocks.stones.pcover, pitfall.quad.dat$species_richness)
 

# run correlation tests between quadrat variables and total abundances:
 
cor.test(pitfall.quad.dat$live.veg.pcover, pitfall.quad.dat$total_abundance)
 
cor.test(pitfall.quad.dat$leaf.litter.pcover, pitfall.quad.dat$total_abundance)
 
cor.test(pitfall.quad.dat$bare.ground.pcover, pitfall.quad.dat$total_abundance)
 
cor.test(pitfall.quad.dat$rocks.stones.pcover, pitfall.quad.dat$total_abundance)

