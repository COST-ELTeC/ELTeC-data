"""
Script to create a summary visualization based on the mean relative frequency of all categories of verbs for each language. 
"""

# === Imports === 

from os.path import join, basename, dirname
import numpy as np
import pandas as pd
import seaborn as sns
from matplotlib import pyplot as plt



# === Parameters === 

wdir = dirname(__file__)
datafolder = join(wdir, "..", "..", "1_data", "2_embeddings", "")
summaryfile = join(wdir, "..", "..", "1_data", "2_embeddings",  "summarydata.csv")
plotfile = join(wdir, "..", "..", "3_results", "2_embeddings", "summary_lineplot.svg")
langs = ["rom", "nor", "deu", "slv", "spa", "hun", "fra", "por", "eng"]



# === Functions === 

def read_verbfreqs(datafile, lang): 
    """
    For one language, extract year and relative frequency of all verbs of inner life. 
    Returns: DataFrame with columns lang, year, relfreqs. 
    """
    with open(datafile, "r", encoding="utf8") as infile: 
        data = pd.read_csv(infile, sep=" ")
    data["relfreqs"] = np.divide(data.loc[:,"innerVerbs"], data.loc[:,"verbs"])
    data.insert(0, "lang", lang)
    data = data.loc[:, ["lang", "year", "relfreqs"]]
    return data



def build_data(): 
    """
    Extract the data by calling the function read_verbfreqs, 
    then combine it into one DataFrame. 
    Returns: DataFrame.
    """
    list_dfs = []
    for lang in langs: 
        datafile = join(datafolder, lang, "manualCounts.dat")
        list_dfs.append(read_verbfreqs(datafile, lang))
    data = pd.concat(list_dfs)
    data = data[data["year"] > 1839] # Remove data outside scope!
    data = data[data["year"] < 1921] # Remove data outside scope!
    with open(summaryfile, "w", encoding="utf8") as outfile: 
        data.to_csv(outfile, sep=";")
    return data



def make_plot(data): 
    """
    Visualize the data as a plot combining multiple regression lines.
    Returns: Nothing, but saves image file to disk.
    """
    params = {
        "linear" : {"lowess" : False, "order" : 1},
        "lowess" : {"lowess" : True, "order" : 1},
        "poly2" : {"lowess" : False, "order" : 2},
    }
    for label,param in params.items(): 
        title = "Relative frequency of all inner life verbs over time per language (" + label + ")"
        filename = plotfile[:-4] + "_" + label + ".svg"
        fig = sns.lmplot(
            data = data,
            x = "year",
            y = "relfreqs",
            hue = "lang",
            scatter = False,
            lowess = param["lowess"],
            order = param["order"],
            height=5.5, 
            aspect=1.65,
            legend = False
            ).set(title=title)
        plt.xlabel("Time period")
        plt.ylabel("Relative frequency")
        legend = plt.legend(
            loc = (1,0.3),
            title = "Languages")
        plt.savefig(
            filename, 
            bbox_inches="tight"
            )



# === Main === 

def main(): 
    # Extract the required data
    data = build_data()
    # Visualize the data
    make_plot(data)
main()
