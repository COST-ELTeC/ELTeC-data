#!/usr/bin/env python3

"""
Script (a) for building a metadata table from XML-TEI 

The XML-TEI files need to be valid against the ELTeC level1 schema.


Output: The script writes one file:
- A TSV file called "metadata_[collection].tsv" with some basic metadata about the texts included in the collection

Please send feedback to Christof at "schoech@uni-trier.de". 
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

collection = "20"


# === Parameters === 

xpaths = {
    "xmlid" : "//tei:TEI/@xml:id", 
    "author-name" : "//tei:titleStmt/tei:author/text()",
    "author-gender" : "//eltec:authorGender/@key",
    "title" : "//tei:titleStmt/tei:title/text()",
    "firstEdition" : "//tei:bibl[@type='firstEdition']/tei:date/text()",
    "digitalSource" : "//tei:bibl[@type='digitalSource']/tei:date/text()",
    "printSource" : "//tei:bibl[@type='printSource']/tei:date/text()",
    "subgenre" : "//tei:term[@type='subgenre']/text()",
     }

ordering = [
    "filename", 
    "xmlid", 
    "author-name", 
    "author-gender", 
    "title", 
    "subgenre", 
    "pub-year-ref",
    "firstEdition", 
    "digitalSource", 
    "printSource"]

sorting = ["pub-year-ref", True] # column, ascending?


# === Functions ===


def open_file(teiFile): 
    """
    Open and parse the XML file. 
    Returns an XML tree.
    """
    with open(teiFile, "r", encoding="utf8") as infile:
        xml = etree.parse(infile)
        return xml



def get_metadatum(xml, xpath): 
    """
    For each metadata key and XPath defined above, retrieve the 
    metadata item from the XML tree.
    Note that the individual identifers for au-ids and title-ids 
    are not split into individual columns.
    """
    try: 
        namespaces = {'tei':'http://www.tei-c.org/ns/1.0',
                      'eltec':'http://distantreading.net/eltec/ns'}       
        metadatum = xml.xpath(xpath, namespaces=namespaces)[0]
    except: 
        metadatum = "NA"
    return metadatum


def get_authordata(xml): 
    """
    Retrieve the author field and split it into constituent parts.
    Expected pattern: "name (alternatename) (birth-death)"
    where birth and death are both four-digit years. 
    The alternate name is ignored. 
    Note that the first and last names are not split into separate
    entries, as this is not always a trivial decision to make.
    """
    try: 
        namespaces = {'tei':'http://www.tei-c.org/ns/1.0'}       
        name = xml.xpath("//tei:titleStmt/tei:author/text()",
                               namespaces=namespaces)[0]
    except: 
        name = "NA"
    return name



def get_pyr(row): 
    if row["firstEdition"] != "nan" and row["firstEdition"] != "NA": 
        pyr = row["firstEdition"]
    elif row["digitalSource"] != "nan" and row["digitalSource"] != "NA": 
        pyr = row["digitalSource"]
    elif row["printSource"] != "nan" and row["printSource"] != "NA": 
        pyr = row["printSource"]
    else: 
        pyr = "NA"
    return pyr
        


def save_metadata(metadata, metadatafile, ordering, sorting): 
    """
    Save all metadata to a CSV file. 
    The ordering of the columns follows the list defined above.
    """
    metadata = pd.DataFrame(metadata)
    metadata["pub-year-ref"] = metadata.apply(get_pyr, axis=1)
    metadata = metadata[ordering]
    metadata = metadata.sort_values(by=sorting[0], ascending=sorting[1])
    print(metadata.head(20))
    print(metadatafile)
    with open(join(metadatafile), "w", encoding="utf8") as outfile: 
        metadata.to_csv(outfile, sep="\t", index=None)


# === Coordinating function ===

def main(collection, xpaths, ordering, sorting):
    """
    From a collection of ELTeC XML-TEI files,
    create a CSV file with some metadata about each file.
    """
    workingDir = join("/", "media", "christof", "Data", "Drive", "03_Academic", "03_Aktionen", "1-Aktuell", "2023_innerlife", "")
    teiFolder = join(workingDir, "data", "xml", collection, "*.xml")
    #print(teiFolder)
    metadatafile = join(workingDir, "data", "metadata_"+ collection + ".tsv")
    allmetadata = []
    counter = 0
    for teiFile in glob.glob(teiFolder): 
        filename,ext = basename(teiFile).split(".")
        #print(filename)
        counter +=1
        keys = []
        metadata = []
        keys.append("filename")
        metadata.append(filename)
        xml = open_file(teiFile)
        name = get_authordata(xml)
        keys.extend(["author-name"])
        metadata.extend([name])
        for key,xpath in xpaths.items(): 
            metadatum = get_metadatum(xml, xpath)
            keys.append(key)
            metadata.append(metadatum)
        allmetadata.append(dict(zip(keys, metadata)))
    print("FILES:", counter)
    save_metadata(allmetadata, metadatafile, ordering, sorting)
    
main(collection, xpaths, ordering, sorting)
