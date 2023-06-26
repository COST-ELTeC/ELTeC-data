"""
Script to count verbs of "inner life" in collections of unannotated files. 
Uses spacy for annotation. (Optimization: use TreeTagger with PRESTO model for 18th century.)
Outputs verb count information in the same style as Lou's and/or Diana's scripts, for compatibility. 

Script written by Christof Schöch (Trier), January 2023. 
"""


# === Imports ===

#== Basics
import os
import random
import re
from os.path import join
import numpy as np
import glob

#== Data
import pandas as pd
import seaborn as sns

# Linguistic annotation
import spacy
import fr_dep_news_trf


# === Global variables ===

workdir = join("/", "media", "christof", "Data", "Drive", "03_Academic", "03_Aktionen", "1-Aktuell", "2023_innerlife", "")
#workdir = join("/", "media", "christof", "Data", "Github", "eltec", "ELTeC-data", "")

verbsfile = join(workdir, "data", "verbs-fra.tsv")
resultsfile = join(workdir, "data", "verbcounts.tsv")

datasets = [
    [join(workdir, "data", "annotated", "18", "*.csv"), join(workdir, "data", "metadata-18.tsv")],
    [join(workdir, "data", "annotated", "19a", "*.csv"), join(workdir, "data", "metadata-19a.tsv")],
    [join(workdir, "data", "annotated", "19b", "*.csv"), join(workdir, "data", "metadata-19b.tsv")],
    [join(workdir, "data", "annotated", "20", "*.csv"), join(workdir, "data", "metadata-20.tsv")],
    ]

items_to_skip = [
    # From 18, but shorter than 5000 words #
    "Voltaire_Consoles",
    "Voltaire_Bramin",
    "Voltaire_Bababec",
    "Voltaire_Songe",
    "Linguet_Voyage",
    "Voltaire_Scarmentado",
    "Voltaire_Eloge",
    "Boufflers_Reine",
    "Beaumont_Prince",
    "Charriere_Observations",
    "Beaumont_Belle",
    "Mouhy_Opuscule",
    # From 18, but published before 1750 # 
    "Arnaud_Epoux",
    "Diderot_Oiseau",
    ]


# === Functions === 


def read_verbsfile(verbsfile): 
    """
    Reads the file with the list of verbs of inner life, 
    along with the different categories of verbs. 
    Returns: Three lists (lemmas, categories, combined labels)
    """
    with open(verbsfile, "r", encoding="utf8") as infile: 
        data = pd.read_csv(infile, sep="\t")
    verblemmas = list(data["lemma"])
    verbcats = list(data["category"])
    verblabels = []
    for i in range(0, len(verblemmas)): 
        verblabels.append(verblemmas[i] + ":" + verbcats[i])
    #print(verblabels)
    return verblemmas, verbcats, verblabels


def read_metadatafile(metadatafile): 
    """
    Reads the metadatafile of the collection. 
    Returns: DataFrame. 
    """
    with open(metadatafile, "r", encoding="utf8") as infile: 
        metadata = pd.read_csv(infile, sep="\t", index_col="filename")
    #print(metadata.head())
    return metadata


def get_pubyear(metadata, basename): 
    """
    Extracts the year of first publication for the current text from the metadata table.
    Returns: int (year)
    """
    try: 
        pubyear = int(metadata.loc[basename, "pub-year-ref"])
    except: 
        pubyear = metadata.loc[basename, "pub-year-ref"]
    if pubyear == 1800: 
        pubyear = 1799
    if pubyear == 1920: 
        pubyear = 1919
    if pubyear == 2000: 
        pubyear = 1999
    return pubyear


def get_authorgender(metadata, basename): 
    """
    Extracts the gender of the author.
    Returns: str (M/F/U)
    """
    authorgender = str(metadata.loc[basename, "author-gender"])
    return authorgender


def get_authorname(metadata, basename): 
    """
    Extracts the name of the author.
    Returns: str 
    """
    authorname = str(metadata.loc[basename, "author-name"])
    return authorname


def get_title(metadata, basename): 
    """
    Extracts the title of the novel
    Returns: str 
    """
    title = str(metadata.loc[basename, "title"])
    return title



def read_annotated(file): 
    """
    Reads an annotated text file from the folder. 
    Returns: list (each item containing one line / token). 
    """
    with open(file, "r", encoding="utf8") as infile: 
        annotated = pd.read_csv(infile, sep="\t")
    try: 
        annotated.columns = ["wordform", "pos", "lemma", "dep", "morph"]
    except: 
        annotated.columns = ["wordform", "pos", "lemma"]
    annotated = annotated.loc[:,["wordform", "pos", "lemma"]]
    return annotated


def count_verbs(annotated, verblemmas): 
    """
    Establishes the number of tokens marked as a verb in the annotated text (=allverbcounts). 
    Establishes the count of each individual verb from the list of verbs of inner life (=indverbcounts). 
    Calculates the sum of counts of verbs of inner life (=innerverbcounts). 
    Returns: int, int, dict
    """
    verbs = annotated[annotated["pos"] == "VERB"]
    #print(verbs.head(10))
    allverbscount = len(verbs)
    innerverbs = verbs[verbs["lemma"].isin(verblemmas)]
    innerverbscount = len(innerverbs)
    indverbcounts = {}
    for lemma in verblemmas: 
        indverbcounts[lemma] = len([verb for verb in list(verbs["lemma"]) if lemma in verb])
    #print(indverbcounts)
    return allverbscount, innerverbscount, indverbcounts


def save_verbcounts(data, verblabels): 
    """
    Saves the combined data from each text to disc. 
    Renames the columns to include the verb category for each individual verb. 
    Returns: nothing (but saves CSV to disk)
    """
    labels = ["0TextId", "year", "author-name", "author-gender", "title", "verbs", "innerVerbs"]
    labels.extend(verblabels)
    data_df = pd.DataFrame.from_dict(data, orient="columns").T
    data_df.columns = labels
    with open(resultsfile, "w", encoding="utf8") as outfile: 
        data_df.to_csv(outfile, sep="\t", index=None)


# === Coordination function === 

def main(verbsfile, datasets):
    """
    Coordindates the entire process. 
    Some things need to be done only once (get metadata, get verbs). 
    Then loops over each text to get year of publication and establish verb counts.
    Verb count information is collected and saved to disk in the end. 
    """
    verblemmas, verbcats, verblabels = read_verbsfile(verbsfile)
    progress = 1
    data = {}
    for dataset in datasets: 
        metadata = read_metadatafile(dataset[1])
        for file in glob.glob(dataset[0]): 
            basename, ext = os.path.basename(file).split(".")
            if basename not in items_to_skip: 
                try: 
                    pubyear = get_pubyear(metadata, basename)
                    print("Now:", progress, basename, pubyear, end=" ")
                    authorgender = get_authorgender(metadata, basename)
                    authorname = get_authorname(metadata, basename)
                    title = get_title(metadata, basename)
                    annotated = read_annotated(file)
                    allverbcounts, innerverbcounts, indverbcounts = count_verbs(annotated, verblemmas)
                    verbdata = {
                        "0TextId" : basename, 
                        "pubyear" : pubyear,  
                        "author-name" : authorname, 
                        "author-gender" : authorgender, 
                        "title" : title, 
                        "verbs" : allverbcounts, 
                        "innerVerbs" : innerverbcounts,
                        } 
                    verbdata.update(indverbcounts)
                    progress +=1
                    print("Done.")
                    data[basename] = verbdata
                except: 
                    print("ERROR:", basename)
    save_verbcounts(data, verblabels)

main(verbsfile, datasets)



