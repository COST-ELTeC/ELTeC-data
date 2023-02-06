"""
Script to visualize the "inner life" data from ELTeC. 
This version works for the extended French data only. 

For each language represented in the dataset, produces 
- a scatterplot with a regression line, for all verbs jointly, per novel
- a boxplot, for all verbs jointly, summarized per decade 
- a comparison plot for the earlier vs. the later part of the data.
- the same series of plots for each category of verbs separately.

Script by Christof Schöch (Trier), November 2022, updated January 2023. 
"""


# === Imports ===

#== Basics
import os
import random
import re
from os.path import join

import numpy as np
#== Data
import pandas as pd
import seaborn as sns
# Visualization
from matplotlib import pyplot as plt
from scipy.stats import mannwhitneyu


# === Global variables ===

workdir = join("/", "media", "christof", "Data", "Github", "eltec", "ELTeC-data", "")
verbcountsfile = join(workdir, "fra_1750-2000", "verbcounts.tsv")
categories = ["perception", "cognition", "volition", "affect", "moral"] #"physiology", 
comparison = [(1750,1799), (1950,1999)]
corpus = "fra_1750-2000"


# === Functions === 

def prepare_data(dataset):
    """
    From the TSV file, calculate a few more columns: 
    Relative frequency of all verbs; decade as a function of year. 
    Also, relative frequency for all verbs in one category.
    """
    #== Read the corpus dataset from file
    with open(dataset, "r", encoding="utf8") as infile: 
        data = pd.read_csv(infile, sep="\t")
    #print(data.head())
    #== Calculate the relative frequency of the inner verbs as a proportion of all verbs.
    #== This is done at the level of all verbs of inner life as a whole 
    #== and at the level of each individual novel, which each has a year of publication.
    data["innerVerbsRel"] = data["innerVerbs"] / data["verbs"] 
    #== Create bins per decade
    #== This will be used for the boxplots per decade. 
    data["decade"] = (data["year"]//10)*10
    #== Create the per-category data
    #== This creates one column for the sum of the frequencies of each category of verbs
    #== The value is the relative frequency calculated against all verbs
    for category in categories: 
        data[category] = np.sum(data.filter(regex=category), axis=1) / data["verbs"]
    return data


def make_boxplot(corpus, data, category): 
    """
    This creates a boxplot of the data per decade.
    If a specific category of verb is indicated, only this is shown. 
    """
    #== Select only the relevant columns for the visualization
    #== Either the relative frequency over all verbs, or over all verbs of one category.
    if category == "all": 
        selection = "innerVerbsRel"
    else: 
        selection = category
    selected = data[["decade", selection]]
    #== Create a boxplot by decade
    plt.figure(figsize=(16,8))
    title = "Verbs of inner life (" + category + ") in ELTeC-" + corpus
    ylabel = "proportion of " + category + " verbs among all verbs"
    xlabel = "decades"
    boxplotname = join(corpus + "_" + category + "-byDecade.png")
    plot = sns.boxplot(
        data = selected,
        x = "decade",
        y = selection,
        palette = "Blues")
    plot.set(xlabel = xlabel, ylabel = ylabel, title = title)
    plot.get_figure().savefig(join(workdir, "results", corpus, boxplotname), dpi=300)
    plt.close("all")


def make_regplot(corpus, data, category): 
    """
    Create a scatterplot with regression line. 
    Each point is one novel. 
    """
    #== Select the relevant data.
    if category == "all": 
        selection = "innerVerbsRel"
    else: 
        selection = category
    selected = data[["year", selection]]
    plt.figure(figsize=(16,8)) 
    title = "Verbs of inner life (" + category + ") in ELTeC-" + corpus
    ylabel = "proportion of " + category + " verbs among all verbs"
    xlabel = "years"
    regplotname = join(corpus + "_" + category + "-perNovel.png")
    plot = sns.regplot(
        data = data,
        x = "year",
        y = selection,
        order = 2)
    plot.set(xlabel = xlabel, ylabel = ylabel, title = title)
    plot.get_figure().savefig(join(workdir, "results", corpus, regplotname), dpi=300)
    plt.close("all")


def make_regplot_pygal(corpus, data, category): 
    """
    Create a scatterplot with metadata using pygal. 
    Each point is one novel. 
    """
    import pygal
    #== Select the relevant data.
    if category == "all": 
        selection = "innerVerbsRel"
    else: 
        selection = category
    #print(data.head())
    selected = data[["0TextId", "author-name", "title", "author-gender", "year", selection]]
    title = "Verbs of inner life (" + category + ") in ELTeC-" + corpus
    ylabel = "proportion of " + category + " verbs among all verbs"
    xlabel = "years"
    scatterplotname = join(corpus + "_" + category + "-perNovel+metadata.svg")
    plot = pygal.XY(
        title = title,
        show_legend = False,
        width=900,
        height = 600,
        #range = (0,0.20)
        )
    for row in selected.iterrows():
        if row[1][3] == "M": 
            #print(row[1][4], row[1][5], row[1][3], end=" ")
            plot.add(str(row[1][0]), [{
                "value" : (int(row[1][4]), round(float(row[1][5]),4)),
                "label" : str(row[1][1]) + ":\n " + str(row[1][2]) + " (" + str(row[1][3]) + ")", 
                "color" : "DarkCyan",
                 }], dots_size=2)
        elif row[1][3] == "F":  
            plot.add(str(row[1][0]), [{
                "value" : (int(row[1][4]), round(float(row[1][5]),4)),
                "label" : str(row[1][1]) + ":\n " + str(row[1][2]) + " (" + str(row[1][3]) + ")", 
                "color" : "DarkSlateBlue"
                }], dots_size=2)
        else: 
            plot.add(str(row[1][0]), [{
                "value" : (int(row[1][4]), round(float(row[1][5]),4)),
                "label" : str(row[1][1]) + ":\n " + str(row[1][2]) + " (" + str(row[1][3]) + ")", 
                "color" : "DarkOrange"
                }], dots_size=2)
    plot.render_to_file(join(workdir, "results", corpus, scatterplotname))
    plt.close("all")




def perform_test(vals1, vals2): 
    """
    Perform a test of statistical difference between the values for the earlier 
    vs. the values for the later period defined in the variable "comparison". 
    """
    #== Determine maximal possible sampling size
    samplesize = (np.min([len(vals1), len(vals2)]))-50
    #print("\n", len(vals1), len(vals2), samplesize)
    #== Sampling from the data
    vals1 = random.sample(vals1, samplesize)
    vals2 = random.sample(vals2, samplesize)
    #== Prepare data for test
    med1 = np.median(vals1)
    med2 = np.median(vals2)
    vals1 = pd.Series(vals1, name=str(comparison[0][0]) + "–" + str(comparison[0][1])+"\n(median="+'{0:.3f}'.format(med1)+")")
    vals2 = pd.Series(vals2, name=str(comparison[1][0]) + "–" + str(comparison[1][1])+"\n(median="+'{0:.3f}'.format(med2)+")")
    stat, p = mannwhitneyu(vals1, vals2)
    return samplesize, vals1, vals2, med1, med2, stat, p


def create_comparisondata(data, comparison, category): 
    """
    Selects the values for all texts that fall 
    into the two periods specified by the comparison parameter. 
    Returns two Series with values for each of the two periods. 
    """
    #== Select the relevant data.
    if category == "all": 
        selection = "innerVerbsRel"
    else: 
        selection = category
    #== First series of data
    vals1 = data[(data["year"] >= comparison[0][0]) & (data["year"] <= comparison[0][1])]
    vals1 = list(vals1.loc[:,selection])
    #print("vals1", len(vals1))
    #== Second series of data
    vals2 = data[(data["year"] >= comparison[1][0]) & (data["year"] <= comparison[1][1])]
    vals2 = list(vals2.loc[:,selection]) 
    #print("vals2", len(vals2))
    #== Based only on the sample selected above, not on the full data.
    samplesize, vals1, vals2, med1, med2, stat, p = perform_test(vals1, vals2)
    return samplesize, vals1, vals2, med1, med2, stat, p


def make_kdeplot(corpus, comparison, vals1, vals2, med1, med2, samplesize, p, cv, avgp, stdp, category): 
    """
    Creates a plot that compares the two selected distributions.
    =================================================================================
    WARNING! Due to the random sampling involved here, results can vary considerably
    between different runs. Until this issue is resolved, skepticism is in order. 
    UPDATE 1: Sample size has been increased as far as possible per dataset. 
    UPDATE 2: The test is performed 100 times and average p-values and their standard
    deviation are now reported. 
    =================================================================================
    """
    #== Sanity checks
    #print(p, avgp)
    #== Labels
    if p < 0.000001: 
        pval = "<0.000001"
    else: 
        pval = '{0:.7f}'.format(p)
    if float(avgp) < 0.000001: 
        avgpval = "<0.000001"
    else: 
        avgpval = '{0:.7f}'.format(avgp)
    if float(stdp) < 0.000001: 
        stdp = "<0.000001"
    else: 
        stdp = '{0:.7f}'.format(stdp)
    plt.figure(figsize=(12,8)) 
    title = "Comparison of verbs of inner life (" + category + ") in ELTeC-" + corpus
    xlabel = "Proportion of verbs \n(size of sample per group=" + str(samplesize) + ") \n(cv=" + str(cv) + ", avg. p=" + str(avgpval) + ", std. p=" + str(stdp) + ")"
    ylabel = "Density (KDE)"
    complotname = join(corpus + "_" + category + "-comparison.png")
    #== Plotting
    plot = sns.displot(
        [vals1, vals2],
        kind="kde",
        fill=True,
        rug=False,
        linewidth=2,
        warn_singular=False)
    plot.set(xlabel = xlabel, ylabel = ylabel, title = title)
    plot.savefig(join(workdir, "results", corpus, complotname), dpi=300)
    plt.close("all")



# === Main === 

def main(): 
    # Create results directory if necessary
    if not os.path.exists(join(workdir, "results", corpus)): 
        os.makedirs(join(workdir, "results", corpus))
    #== Prepare the data
    data = prepare_data(verbcountsfile)
    #== Create some plots (boxplot, regplot)
    print("--", "all verbs:", end='')
    make_boxplot(corpus, data, category="all")
    print(" boxplot✓", end='')
    make_regplot(corpus, data, category="all")
    make_regplot_pygal(corpus, data, category="all")
    print(" regplot✓", end='')
    #== Create a comparison plot
    #== Create sample and test multiple times to calculate average p-value
    cv = 100
    allp = []
    for i in range(0,cv):
        samplesize, vals1, vals2, med1, med2, stat, p = create_comparisondata(data, comparison, category="all")
        allp.append(p)
    avgp = np.mean(allp)
    stdp = np.std(allp)
    #print("\n", cv, allp, avgp, stdp)
    #print("\n", avgp, stdp)
    #== Create sample and test once for the visualization
    samplesize, vals1, vals2, med1, med2, stat, p = create_comparisondata(data, comparison, category="all")
    #== Check for minimal sample size and non-zero median (will be zero if no data)
    if samplesize > 25 and med1 != 0: 
        #== Create the density plot with statistical indicators
        make_kdeplot(corpus, comparison, vals1, vals2, med1, med2, samplesize, p, cv, avgp, stdp, category="all") 
        print(" kdeplot✓", end="")
    else: 
        print(" kdeplot⚠️")
        print("   ERROR: Sample size too small for KDE plot.", end="")
    #== Create the per-category data visualizations
    for category in categories: 
        print("\n-- " + category + ":",  end="")
        if np.sum(data[category]) != 0:
            make_boxplot(corpus, data, category)
            print(" boxplot✓", end="")
        else: 
            print(" boxplot⚠️", end="")
        if np.sum(data[category]) != 0:
            make_regplot(corpus, data, category)
            make_regplot_pygal(corpus, data, category)
            print(" regplot✓", end="")
        else: 
            print(" regplot⚠️", end="")
        #== Create sample and test multiple times to calculate average p-value
        cv = 100
        allp = []
        for i in range(0,cv):
            samplesize, vals1, vals2, med1, med2, stat, p = create_comparisondata(data, comparison, category="all")
            allp.append(p)
        avgp = np.mean(allp)
        stdp = np.std(allp)
        #print("\n", cv, allp, avgp, stdp)
        #print(" ", avgp, stdp, end="")
        #== Create sample and test once for the visualization
        samplesize, vals1, vals2, med1, med2, stat, p = create_comparisondata(data, comparison, category)
        # Check for minimal sample size and non-zero median (will be zero if no data)
        if samplesize > 25 and med1 != 0:
            #== Create the density plot with statistical indicators
            make_kdeplot(corpus, comparison, vals1, vals2, med1, med2, samplesize, p, cv, avgp, stdp, category) 
            print(" kdeplot✓", end="")
        else: 
            print(" kdeplot⚠️", end="")
    print("\nDone.")

main()
