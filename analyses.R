# Title: Data Analyses
# Author: Arwenn Evenstar Kummer
# Date created: 19/02/2025  

# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# For a more user-friendly version with justification and description of each step in the process, please refer to the quarto document uploaded to the same GitHub repository as this file (file name: Step by Step Analyses)
# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

# Preamble: --==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==
# The data set we will analyse involves pitfall trapped ants collected from two different vegetation types - Fynbos and Eucalyptus/Gum trees. The data set contains species counts, species names and quantitative soil surface data, collected using a quadrat placed over the sample site where each pitfall trap was placed. This analysis is simple and rudimentary. It is intended to provide a basic overview of the data set and to identify any potential relationships between the variables, for the purpose of the Data Management Honours Module, 2025
# --==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--


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


# End ----

# Session info: -----
# R version 4.4.2 (2024-10-31 ucrt)
# Platform: x86_64-w64-mingw32/x64
# Running under: Windows 11 x64 (build 26100)
# 
# Matrix products: default
# 
# 
# locale:
#   [1] LC_COLLATE=English_South Africa.utf8  LC_CTYPE=English_South Africa.utf8    LC_MONETARY=English_South Africa.utf8
# [4] LC_NUMERIC=C                          LC_TIME=English_South Africa.utf8    
# 
# time zone: Africa/Johannesburg
# tzcode source: internal
# 
# attached base packages:
#   [1] stats     graphics  grDevices utils     datasets  methods   base     
# 
# other attached packages:
#   [1] readxl_1.4.3    lubridate_1.9.4 forcats_1.0.0   stringr_1.5.1   dplyr_1.1.4     purrr_1.0.2     readr_2.1.5     tidyr_1.3.1    
# [9] tibble_3.2.1    ggplot2_3.5.1   tidyverse_2.0.0
# 
# loaded via a namespace (and not attached):
#   [1] gtable_0.3.6      compiler_4.4.2    tidyselect_1.2.1  scales_1.3.0      R6_2.5.1          labeling_0.4.3    generics_0.1.3   
# [8] knitr_1.49        munsell_0.5.1     pillar_1.9.0      tzdb_0.4.0        rlang_1.1.4       utf8_1.2.4        stringi_1.8.4    
# [15] xfun_0.49         timechange_0.3.0  cli_3.6.3         withr_3.0.2       magrittr_2.0.3    grid_4.4.2        rstudioapi_0.17.1
# [22] hms_1.1.3         lifecycle_1.0.4   vctrs_0.6.5       evaluate_1.0.1    glue_1.8.0        farver_2.1.2      cellranger_1.1.0 
# [29] fansi_1.0.6       colorspace_2.1-1  tools_4.4.2       pkgconfig_2.0.3  




