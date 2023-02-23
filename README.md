# Overview
Main focus of the project was to create linear regression models for all possible combinations of columns from two, rather large, files containing information about breeding values and SNPs.

In order to optimize time needed to complete all of the necessary steps, some of the processes were done in parallel using R *parallel* library.

# Data
Two .csv files were used.

**Values_Y.csv**
Contains information about 6 different breeding values of 1000 individuals each.

**SNPs_X.csv**
Contains information about 10 000 different SNPs of 1000 individuals each. Individuals genotypes are coded as:

* 0 - 0/0 - ref. homozygote
* 1 - 0/1 - heterozygote
* 2 - 1/1 - alt. homozygote

# Outcome
Linear regression model was created for every possible combination of 
