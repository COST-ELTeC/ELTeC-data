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
plotfile = join(wdir, "..", "..", "3_results", "2_embeddings", "summary_lineplot.svg")
langs = ["nor", "rom", "deu", "slv", "spa", "hun", "fra", "por", "eng"]



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
    return data



def make_plot(data): 
    """
    Visualize the data as a plot combining multiple regression lines.
    Returns: Nothing, but saves image file to disk.
    """
    title = "Relative frequency of all inner life verbs over time per language"
    fig = sns.lmplot(
        data = data,
        x = "year",
        y = "relfreqs",
        hue = "lang",
        scatter = False,
        height=6, 
        aspect=1.5,
        ).set(title=title)
    #plt.figure(figsize=(12,6))
    plt.savefig(
        plotfile, 
        bbox_inches="tight"
        )



# === Main === 

def main(): 
    # Extract the required data
    data = build_data()
    # Visualize the data
    make_plot(data)
main()
