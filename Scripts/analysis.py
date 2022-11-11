"""
Script to analyze and visualize the "inner life" data from ELTeC. 
"""

# === Imports ===

import os
from os.path import join
import pandas as pd
import numpy as np
import random
from matplotlib import pyplot as plt
import seaborn as sns
from scipy.stats import mannwhitneyu


# === Global variables ===

#workdir = join(os.path.realpath(os.path.dirname(__file__)))
workdir = '/home/lou/Public/ELTeC-data/'
corpora = [ "deu", "eng", "fra", "hun", "nor", "por", "rom", "slv", "spa"]

comparison = [(1840,1869), (1889,1919)]
samplesize = 20


# === Functions === 

def read_data(dataset): 
    with open(dataset, "r", encoding="utf8") as infile: 
        data = pd.read_csv(infile, sep=" ")
        #print(data.head())
    return data


def prepare_data(data):
    #== Calculate the relative frequency of the inner verbs as a proportion of all verbs.
    # This is done at the level of all verbs of inner life as a whole 
    # and at the level of each individual novel, which each has a year of publication.
    data["innerVerbsRel"] = data["innerVerbs"] / data["verbs"] 
    #== Create bins per decade
    # This will be used for the boxplots per decade. 
    data["decade"] = (data["year"]//10)*10
    #== Select only the relevant columns for the visualization
    # We only need year, decade and the relative frequency of the verbs of inner life. 
    data = data[["year", "decade", "innerVerbsRel"]]
    #print(data.head())
    return data


def visualize_data(data, corpus): 
    #== Create a boxplot by decade
    plt.figure()
    title="Categories of Verbs of inner life in ELTeC-" + corpus
    xlabel="Relative frequency"
    ylabel="Decades"
    plot = sns.boxplot(data=data, x="decade", y="innerVerbsRel", palette="Blues")
    plot.set(xlabel=xlabel, ylabel=ylabel, title=title)
    fig = plot.get_figure()
    boxplotname = join(workdir, "results", corpus + "-cats-boxplot-decades.png")
    fig.savefig(join(workdir, boxplotname), dpi=300)
    plt.close()
    #== Create a scatterplot with regression line
    # Here, each point is the joint frequency of all verbs of inner life in one novel.
    plt.figure() 
    title="Categories of Verbs of inner life in ELTeC-" + corpus
    xlabel="Relative frequency"
    ylabel="Years"
    plot = sns.regplot(data=data, x="year", y="innerVerbsRel", order=1)
    plot.set(xlabel=xlabel, ylabel=ylabel, title=title)
    fig = plot.get_figure()
    regplotname = join(workdir, "results", corpus + "-scatter+regression.png")
    fig.savefig(join(workdir, regplotname), dpi=300)
    plt.close()


def filter_data(data, comparison, samplesize): 
    """
    Selects the average sentence length values for all texts that fall 
    into the two periods specified by the comparison parameter. 
    Returns two Series with values for each of the two periods. 
    """
    #== First series of data
    vals1 = data[(data["year"] >= comparison[0][0]) & (data["year"] <= comparison[0][1])]
    vals1 = list(vals1.loc[:,"innerVerbsRel"])
    #print("vals1", len(vals1))
    vals1 = random.sample(vals1, samplesize)
    med1 = np.median(vals1)
    vals1 = pd.Series(vals1, name=str(comparison[0][0]) + "–" + str(comparison[0][1])+"\n(median="+'{0:.2f}'.format(med1)+")")
    #== Second series of data
    vals2 = data[(data["year"] >= comparison[1][0]) & (data["year"] <= comparison[1][1])]
    vals2 = list(vals2.loc[:,"innerVerbsRel"])   
    #print("vals2", len(vals2))
    vals2 = random.sample(vals2, samplesize)
    med2 = np.median(vals2)
    vals2 = pd.Series(vals2, name=str(comparison[1][0]) + "–" + str(comparison[1][1])+"\n(median="+'{0:.2f}'.format(med2)+")")
    return vals1, vals2, med1, med2


def test_significance(vals1, vals2): 
    """
    Perform a significance test for the difference between the two distributions.
    At the moment, based only on the sample selected above, not on the full data.
    """
    stat, p = mannwhitneyu(vals1, vals2)
    return stat, p


def plot_seaborn(corpus, comparison, vals1, vals2, med1, med2, samplesize, p): 
    """
    Creates a plot that compares the distributions 
    """
    #== Labels
    if p < 0.00001: 
        pval = "<0.00001"
    else: 
        pval = '{0:.5f}'.format(p)
    plt.figure() 
    title="Comparison of categories of verbs of inner life in ELTeC-" + corpus
    xlabel="Relative frequency\n(samplesize="+str(samplesize)+", p="+pval+")"
    ylabel="Density (KDE)"
    #== Plotting
    plot = sns.displot([vals1, vals2], kind="kde", fill=True, rug=False, linewidth=2)
    plot.set(xlabel=xlabel, ylabel=ylabel, title=title)
    complotname = join(workdir, "results", corpus + "-comparison.png")
    plot.savefig(join(workdir, complotname), dpi=300)
    plt.close()
    

# === Main === 

def main(): 
    for corpus in corpora: 
        #== Prepare the data
        dataset = join(workdir, corpus, "manualCounts.dat")
        data = read_data(dataset)
        data = prepare_data(data)
        #== Create some plots (boxplot, regplot)
        visualize_data(data, corpus)
        #== Compare two time-frames
        if corpus not in ["nor", "rom", "slv"]:
          vals1, vals2, med1, med2 = filter_data(data, comparison, samplesize)
          stat, p = test_significance(vals1, vals2)
          plot_seaborn(corpus, comparison, vals1, vals2, med1, med2, samplesize, p) 
        #== Finish.
        print("Done:", corpus)

main()
