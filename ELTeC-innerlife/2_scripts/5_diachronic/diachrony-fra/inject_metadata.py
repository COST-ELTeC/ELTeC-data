#!/usr/bin/env python3

"""
Script for injecting publication date from metadata table into XML header. 

Script developed by Christof Schöch (Trier), February 2023. 
Please send feedback to "schoech@uni-trier.de". 
"""




# === Import statements ===

import os
import re
import glob
from os.path import join
from os.path import basename
import pandas as pd
from lxml import etree
from collections import Counter


# === Files and folders ===

wdir = join("/", "media", "christof", "Data", "Drive", "03_Academic", "03_Aktionen", "1-Aktuell", "2023_innerlife")
xmlfolder_in = join(wdir, "data", "xml", "20_alt", "*.xml")
xmlfolder_out = join(wdir, "data", "xml", "20", "")
metadatafile = join(wdir, "data", "roman20-metadata-drive.tsv")


# === Functions ===


def read_xmlfile(xmlfile): 
    """
    Open and read the XML file. 
    Returns: string
    """
    with open(xmlfile, "r", encoding="utf8") as infile:
        xmlstring = infile.read()
    return xmlstring


def read_csvfile(metadatafile): 
    """
    Open and read the CSV file with the metadata. 
    Returns: DataFrame. 
    """
    with open(metadatafile, "r", encoding="utf8") as infile:
        metadata = pd.read_csv(infile, sep="\t")
    metadata = metadata[["identifier", "publ-first", "publ-edition"]]
    metadata.set_index("identifier", inplace=True)
    #print(metadata.head())
    return metadata


def select_years(metadata, fileid): 
    """
    Based on the file identifier, select the year(s) of publication. 
    Returns: list of integers. 
    """
    publ_first = metadata.loc[fileid, "publ-first"] 
    publ_edition = metadata.loc[fileid, "publ-edition"]
    #if publ_first == "NaN": 
    #    publ_first = "unavailable"
    #if publ_edition == "NaN": 
    #    publ_edition = "unavailable"
    return publ_first, publ_edition


def inject_into_xml(xmlstring, publ_first, publ_edition): 
    """
    Place the publication year(s) into the right places in the TEI Header. 
    Then, save the XML file to disc. 
    """
    xmlstring = re.sub(
        "<bibl type=\"firstEdition\">\n(.*?)<date>(.*?)</date>",
        "<bibl type=\"firstEdition\">\n\\1<date>" + str(publ_first) + "</date>",
        xmlstring)
    xmlstring = re.sub(
        "</sourceDesc>",
        "<bibl type=\"digitalSource\">\n        <date>" + str(publ_edition) + "</date>\n      </bibl>\n    </sourceDesc>",
        xmlstring)
    #print("\n", xmlstring[1300:1600], "\n")
    return xmlstring


def save_xmlstring(xmlstring, xmlfolder_out, fileid): 
    with open(join(xmlfolder_out, fileid + ".xml"), "w", encoding="utf8") as outfile: 
        outfile.write(xmlstring)


# === Coordinating function ===

def main():
    metadata = read_csvfile(metadatafile)
    for xmlfile in glob.glob(xmlfolder_in): 
        fileid, ext = os.path.basename(xmlfile).split(".") 
        xmlstring = read_xmlfile(xmlfile)
        publ_first, publ_edition = select_years(metadata, fileid)
        print(fileid, publ_first, publ_edition)
        xmlstring = inject_into_xml(xmlstring, publ_first, publ_edition)
        save_xmlstring(xmlstring, xmlfolder_out, fileid)
main()
