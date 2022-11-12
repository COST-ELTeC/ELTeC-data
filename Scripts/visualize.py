
"""
Script to visualize the "inner life" data from ELTeC. 

For each language represented in the dataset, produces 
- a scatterplot with a regression line, for all verbs jointly, per novel
- a boxplot, for all verbs jointly, summarized per decade 
- a comparison plot for the earlier vs. the later part of the data.
- the same series of plots for each category of verbs separately.

Script by Christof Schöch (Trier), November 2022. 
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

workdir = join(os.path.realpath(os.path.dirname(__file__)), "..")
corpora = ["deu", "eng", "fra", "hun", "nor", "por", "rom", "slv", "spa"] # no data: pol, srp
categories = ["perception", "cognition", "volition", "affect", "physiology", "moral"]
comparison = [(1840,1869), (1889,1919)]
samplesize = 20


# === Functions === 

def prepare_data(dataset):
    """
    From the original ".dat" file, calculate a few more columns: 
    Relative frequency of all verbs; decade as a function of year. 
    Also, relative frequency for all verbs in one category.
    """
    #== Read the corpus dataset from file
    with open(dataset, "r", encoding="utf8") as infile: 
        data = pd.read_csv(infile, sep=" ")
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
    plt.figure()
    title = "Verbs of inner life (" + category + ") in ELTeC-" + corpus
    ylabel = "Relative frequency"
    xlabel = "Decades"
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
    selected = data[["decade", selection]]
    plt.figure() 
    title = "Verbs of inner life (" + category + ") in ELTeC-" + corpus
    ylabel = "Relative frequency"
    xlabel = "Years"
    regplotname = join(corpus + "_" + category + "-perNovel.png")
    plot = sns.regplot(
        data = data,
        x = "year",
        y = selection,
        order = 2)
    plot.set(xlabel = xlabel, ylabel = ylabel, title = title)
    plot.get_figure().savefig(join(workdir, "results", corpus, regplotname), dpi=300)
    plt.close("all")


def create_comparisondata(data, comparison, samplesize, category): 
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
    vals1 = random.sample(vals1, samplesize)
    med1 = np.median(vals1)
    vals1 = pd.Series(vals1, name=str(comparison[0][0]) + "–" + str(comparison[0][1])+"\n(median="+'{0:.2f}'.format(med1)+")")
    #== Second series of data
    vals2 = data[(data["year"] >= comparison[1][0]) & (data["year"] <= comparison[1][1])]
    vals2 = list(vals2.loc[:,selection])   
    #print("vals2", len(vals2))
    vals2 = random.sample(vals2, samplesize)
    med2 = np.median(vals2)
    vals2 = pd.Series(vals2, name=str(comparison[1][0]) + "–" + str(comparison[1][1])+"\n(median="+'{0:.2f}'.format(med2)+")")
    stat, p = mannwhitneyu(vals1, vals2)
    #== Perform a significance test for the difference between the two distributions.
    #== Based only on the sample selected above, not on the full data.
    return vals1, vals2, med1, med2, stat, p


def make_kdeplot(corpus, comparison, vals1, vals2, med1, med2, samplesize, p, category): 
    """
    Creates a plot that compares the two selected distributions.
    =================================================================================
    WARNING! Due to the random sampling involved here, results can vary considerably
    between different runs (see the "fra-all-comparison" plots in "results/fra"). 
    Until this issue is resolved, skepticism is in order. 
    =================================================================================
    """
    #== Labels
    if p < 0.00001: 
        pval = "<0.00001"
    else: 
        pval = '{0:.5f}'.format(p)
    plt.figure() 
    title = "Comparison of verbs of inner life (" + category + ") in ELTeC-" + corpus
    xlabel = "Relative frequency\n(samplesize=" + str(samplesize) + ", p=" + pval + ")"
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
    for corpus in corpora: 
        print("\nNow working on corpus:", corpus)
        # Create results directory if necessary
        if not os.path.exists(join(workdir, "results", corpus)): 
            os.makedirs(join(workdir, "results", corpus))
        #== Prepare the data
        dataset = join(workdir, "data", corpus, "manualCounts.dat")
        data = prepare_data(dataset)
        #== Create some plots (boxplot, regplot)
        print("--", "all verbs:", end='')
        make_boxplot(corpus, data, category="all")
        print(" boxplot✓", end='')
        make_regplot(corpus, data, category="all")
        print(" regplot✓", end='')
        #== Create a comparison plot
        try: 
            vals1, vals2, med1, med2, stat, p = create_comparisondata(data, comparison, samplesize, category="all")
            make_kdeplot(corpus, comparison, vals1, vals2, med1, med2, samplesize, p, category="all") 
            print(" kdeplot✓", end="")
        except ValueError: 
            print(" ERROR")
            print("   The selected sample size is larger than the available data.")
            print("   The comparison plot is skipped for " + corpus + " / " + category + ".", end="")
        #== Create the per-category data visualizations
        for category in categories: 
            print("\n-- " + category + ":",  end="")
            make_boxplot(corpus, data, category)
            print(" boxplot✓", end="")
            make_regplot(corpus, data, category)
            print(" regplot✓", end="")
            try: 
                vals1, vals2, med1, med2, stat, p = create_comparisondata(data, comparison, samplesize, category)
                make_kdeplot(corpus, comparison, vals1, vals2, med1, med2, samplesize, p, category) 
                print(" kdeplot✓", end="")
            except ValueError: 
                print(" ERROR")
                print("   The selected sample size is larger than the available data.")
                print("   The comparison plot is skipped for " + corpus + " / " + category + ".", end="")

        print("\nDone.")
    print("\nAll done.\n")

main()
