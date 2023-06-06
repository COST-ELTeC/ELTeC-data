## Set of scripts used for the analysis of verbs of inner life for a composite corpus of French novels from 1750 to 2000

## Scripts 

The main scripts used for this analysis: 

* annotate.py: Uses spaCy to annotate a plain text version of each novel; creates a TSV file containing one token per line, with wordform, pos, lemma, dep (dependency) and morph (morphology) information. 
* count.py: Based on the list of French verbs of inner life with categories (verbs-fra.tsv), and the respective metadata files (one for each subcorpus), creates a table with metadata and verbcount information for each novel in the composite corpus. Saves the result as verbcounts.tsv. 
* visualize_fra.py: Based on the verbcounts.tsv table, summarizes the individual verb counts by category and normalizes the frequencies based on the total number of verbs. Creates the usual visualizations for this data: A set of boxplots as a per-decade summary; a scatterplot showing each novel with a regression line; an alternative scatterplot with some embedded metadata; a Kernel Density Estimation plot with the distribution of the relative verb frequencies for two distinct time periods (early and late). 

The remaining scripts are helper scripts dealing with metadata and parametrized plain text extraction from the original XML files. 

## Datasets 

The composite corpus consists of four subcorpora for distinct periods of French literary history: 

* 18: 205 novels and shorter narrative texts from the time period 1750-1800. Created by the project Mining and Modeling Text, editor Julia Röttgermann. 
* 19a: 100 novels corresponding to ELTeC-fra. 
* 19b: 370 novels corresponding to ELTeC-fra-ext1. 
* 20: 425 novels (almost equal parts of policier, sentimental, scifi and blanche per decade) from the Zeta and Company corpus. Under copyright. 