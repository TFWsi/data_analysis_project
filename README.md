# Overview
The main focus of the project was to create linear regression models for all possible combinations of variables from two, rather large, files containing information about breeding values and SNPs in dairy cattle.

To optimize the time needed to complete all of the necessary steps, some of the processes were done in parallel using R *parallel* library.

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
Linear regression models were created for all possible combinations between breeding values and SNPs, where breeding values were dependent variables, and SNPs were used as independent variables to show their impact on a particular trait.

As a final result, only the p-value and estimate of the independent variable were gathered into one large file describing all of the created linear regression models.
