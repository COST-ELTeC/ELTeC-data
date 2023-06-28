"""
Script to establish descriptive corpus statistics for the extended French corpus. 
"""

# === Imports === 

import re
import pandas as pd
import numpy as np
from glob import glob 
from os.path import join, dirname, basename



# === Parameters === 

wdir = join("/", "media", "christof", "Data", "Github", "")
metadatafile = join(wdir, "eltec", "ELTeC-data", "ELTeC-innerlife", "1_data", "5_diachronic", "fra_1750-2000", "metadata-20.tsv")
corpusfolder = join(wdir, "Zeta-and-company", "roman20", "plain", "")



# === Functions === 

def get_idnos(metadatafile): 
    """
    Get all the text identifiers for a given metadata table. 
    Returns: list
    """
    with open(metadatafile, "r", encoding="utf8") as infile: 
        metadata = pd.read_csv(infile, sep="\t")
    idnos = list(metadata.loc[:,"filename"])
    #print(idnos)
    return idnos



def get_wordcounts(idnos): 
    """
    Open each text file, split it into tokens, count the tokens. 
    Returns: dict (idno and wordcount)
    """
    wordcounts = {}
    errors = 0
    for idno in idnos: 
        filename = join(corpusfolder, idno + ".txt")
        try: 
            with open(filename, "r", encoding="utf8") as infile: 
                wordcounts[idno] = len(re.split("\W+", infile.read()))
        except: 
            print("ERROR for", idno)
            errors +=1
    print("errors:", errors)
    #for idno,wc in wordcounts.items(): 
    #    print(idno, wc)
    return wordcounts



def get_stats(wordcounts): 
    numtexts = len(wordcounts.values())
    shortest = sorted(wordcounts.values())[0]
    median = np.median(list(wordcounts.values()))
    longest = sorted(wordcounts.values())[-1]
    tokens = np.sum(list(wordcounts.values()))
    stdev = np.std(list(wordcounts.values()))
    print("\nroman20")
    print("- numtexts", numtexts)
    print("- shortest", shortest)
    print("- median", median)
    print("- longest", longest)
    print("- tokens", tokens)
    print("- stdev", stdev)



# === Main ===

def main(): 
    idnos = get_idnos(metadatafile)
    wordcounts = get_wordcounts(idnos)
    get_stats(wordcounts)
main()