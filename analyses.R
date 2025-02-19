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

# the column names for the quadrat data are confusing. let's simplify them, but keep the fact that these values are a percentage of total coverag explicit (through .pcover) 
colnames(quad.dat) <- c("site", "live.veg.pcover", "leaf.litter.pcover", "bare.ground.pcover", "rocks.stones.pcover")

## check for missing values ----
sum(is.na(quad.dat))
sum(is.na(pitfall.dat))

## check for duplicates ----
sum(duplicated(quad.dat))
sum(duplicated(pitfall.dat))

# Suggested visualisations - Branch Point 1: ----
# We want to see what the relationship is between site (i.e. fynbos and eucalyptus gums), total abundance, and species richness.
# We will use the ggplot2 package to create a bar plot of the total abundance of ants per site, and a scatter plot of species richness per site. 

### total abundances per site----

# we want to generate the total abundance of ants per site; i.e. sum the observed species counts per row. Thus we need to sum across the columns of the data set. We will do this using the mutate function from the dplyr package. 

pitfall_total_abundance <- pitfall.dat %>%
  group_by(pitfall) %>%
  mutate(total_abundance = rowSums(across(everything())))

### total species richness per site ----

# Now we want to generate the total species richness per site. For this we need to count how many columns have a value greater than 0 (i.e. the species was detected), and have each occurrence of >0 logged as a count. Then we sum those counts for each row, to obtain the number of species found per site.

pitfall_species_richness <- pitfall.dat %>%
  group_by(pitfall) %>%
  mutate(species_richness = rowSums(across(everything()) > 0))

# now we want to combine both the species richness and total abundance columns onto the original data set of pitfall trap data. We will do this using the left_join function from tidyverse.
pitfall.dat <- pitfall.dat %>%
  left_join(pitfall_total_abundance) %>%
  left_join(pitfall_species_richness)


# Data Visualisation: ----
# Now we are all set to create the plots. We will use the ggplot2 package from tidyverse as well for this.


# Box plot of total abundance per site ----
ggplot(pitfall.dat, aes(x = pitfall, y = total_abundance)) +
  geom_bar(stat = "identity") +
  labs(title = "Total Abundance of Ants per Site",
       x = "Site",
       y = "Total Abundance") +
  theme_classic()
# change the code above to make the bar colours the same


# box plot of species richness per site ---
ggplot(pitfall.dat, aes(x = pitfall, y = species_richness)) +
  geom_bar(stat = "identity") +
  labs(title = "Species Richness per Site",
       x = "Site",
       y = "Species Richness") +
  theme_classic()


# Suggested Statistics
