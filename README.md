# data-management-2025

Repository for Data Management Honours Module at UCT (2025).

The purpose of this repository is to fulfil an assignment for the Honour's Data Management Course, 2025.

The contents of this repository include an RScript with data analysis and data files based on a third year project from 2024. Data collection was carried out by myself with the assistance of Timothy Muasya and Lindiwe Khosa, during a field trip in Jan-Feb 2024 (CC BY 4.0 International: https://creativecommons.org/licenses/by/4.0/deed.en). The sorting and processing of data used in this demonstratory analysis (i.e. counting, identifying and sorting the ants from each pitfall trap) was carried out by myself. 

The data includes ant genus/species names, species counts, and percentage cover of various soil surface features (i.e. bare ground, leaf litter etc.) around each pitfall trap, assessed using a quadrat. We'll be investigating the relationships between vegetation type, soil surface features and how they might affect ant species richness and abundances. Basic data anaylses and visualisations were performed in the RScript (analyses.R), and versions of the raw and clean data is available in the data folder, in .xlsx and .csv formats where relevant. Meta data, the raw data file, (all_data_raw.xlsx, metadata_raw.csv) and the output figures can be found in the data/raw folder, and images folder respectively. The data used in analyses (pitfall_data_clean.csv, quadrat_data_clean.csv) are found in the main branch.

In addition to the RScript, a more thorough, step-by-step guide to my thought process is documented in a more user-friendly manner in the analyses_quarto.qmd and analyses_quarto.html files. These files include written paragraphs and code chunks, extra details into the functions and packages used, and the justification behind my analysis and coding process. It is intended for those less familiar with R, to guide them through the coding process. If there are issues with running the main RScript (but hopefully there aren't), the Quarto document may hold a clearer explanation which may assist in troubleshooting. 

To replicate the analyses, you can follow this link to run the session online through MyBinder: [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/EvenstarA/data-management-2025/HEAD)

Alternatively, you will need to download the following files from this repository to your computer if you want to run it offline. It may be beneficial to read the session_info file for software details. 
- analyses.R
- pitfall_data_clean.csv
- quadrat_data_clean.csv
- analyses_quarto.qmd

Happy analyses!
