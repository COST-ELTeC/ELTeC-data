#!/usr/bin/env python3

"""
Script (a) for building a metadata table from ELTeC XML-TEI 
and (b) for creating some basic corpus composition statistics.

The XML-TEI files need to be valid against the ELTeC level1 schema.

Requirements: This script runs in Thonny, https://thonny.org/,
if the packages pandas and lxml are installed via the package manager.
Advanced users of Python will know how to get it to work in their preferred environment. 

Usage: The only parameter you should need to adjust is the path
encoded in the variable "workingDir" (line 47), to point it to the appropriate
language collection folder.

Assuming you cloned the Scripts repository to the same place as the language
collections repositories, you go one level up ("..") and then down
to the appropriate language collection folder (e.g. "ELTec-por"). 
Advanced users may want to change the XPath expressions to match their TEI encoding.

Output: The script writes one file:
- A TSV file called "[collection]_metadata.tsv" with some basic metadata about the texts included in the collection

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

collection = "ELTeC-pol"
level = "level1"


# === Parameters === 

xpaths = {"xmlid" : "//tei:TEI/@xml:id", 
          "title" : "//tei:titleStmt/tei:title/text()",
          "title-ids" : "//tei:titleStmt/tei:title/@ref",
          "au-ids" : "//tei:titleStmt/tei:author/@ref",
          "numwords" : "//tei:extent/tei:measure[@unit='words']/text()",
          "narr-per" : "//tei:textClass/tei:keywords/tei:term[@type='narrative-perspective']/text()",
          "subgenre" : "//tei:textClass/tei:keywords/tei:term[@type='subgenre']/text()",
          "au-gender" : "//tei:textDesc/eltec:authorGender/@key",
          "sizeCat" : "//tei:textDesc/eltec:size/@key",
          "reprintCount" : "//tei:textDesc/eltec:reprintCount/@key",
          "time-slot" : "//tei:textDesc/eltec:timeSlot/@key",
          "firsted-yr" : "//tei:bibl[@type='firstEdition']/tei:date/text()",
          "printSource" : "//tei:bibl[@type='printSource']/tei:date/text()",
          "digitalSource" : "//tei:bibl[@type='digitalSource']/tei:publisher/text()",
          "language" : "//tei:langUsage/tei:language/@ident"}

ordering = ["filename", "xmlid", "au-name", "title", "au-birth", "au-death", "au-ids", "digitalSource", "printSource", "firsted-yr", "title-ids", "language", "numwords", "subgenre", "narr-per", "au-gender", "sizeCat", "reprintCount", "time-slot"]

sorting = ["firsted-yr", True] # column, ascending?


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
    metadatum = re.sub(": ELTeC edition", "", metadatum)
    metadatum = re.sub(" : ELTeC edition", "", metadatum)
    metadatum = re.sub(" : édition ELTeC", "", metadatum)
    metadatum = re.sub(" : edition ELTeC", "", metadatum)
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
        authordata = xml.xpath("//tei:titleStmt/tei:author/text()",
                               namespaces=namespaces)[0]
        name = re.search("(.*?) \(", authordata).group(1)
        birth = re.search("\((\d\d\d\d)", authordata).group(1)
        death = re.search("(\d\d\d\d)\)", authordata).group(1)
    except: 
        name = "NA"
        birth = "NA"
        death = "NA"        
    return name,birth,death



def save_metadata(metadata, metadatafile, ordering, sorting): 
    """
    Save all metadata to a CSV file. 
    The ordering of the columns follows the list defined above.
    """
    metadata = pd.DataFrame(metadata)
    metadata = metadata[ordering]
    metadata = metadata.sort_values(by=sorting[0], ascending=sorting[1])
    print(metadatafile)
    with open(join(metadatafile), "w", encoding="utf8") as outfile: 
        metadata.to_csv(outfile, sep="\t", index=None)


# === Coordinating function ===

def main(collection, level, xpaths, ordering, sorting):
    """
    From a collection of ELTeC XML-TEI files,
    create a CSV file with some metadata about each file.
    """
    current_dir = join(os.path.realpath(os.path.dirname(__file__)))
    workingDir = join(current_dir, "..", "..", collection)
    teiFolder = join(workingDir, level, "*.xml")
    metadatafile = join(current_dir, "..", "..", collection, collection+"_metadata.tsv")
    allmetadata = []
    counter = 0
    for teiFile in glob.glob(teiFolder): 
        filename,ext = basename(teiFile).split(".")
        #print(filename)
        try: 
            if "schemas" not in filename:
                counter +=1
                keys = []
                metadata = []
                keys.append("filename")
                metadata.append(filename)
                xml = open_file(teiFile)
                name,birth,death = get_authordata(xml)
                keys.extend(["au-name", "au-birth", "au-death"])
                metadata.extend([name, birth, death])
                for key,xpath in xpaths.items(): 
                    metadatum = get_metadatum(xml, xpath)
                    keys.append(key)
                    metadata.append(metadatum)
                allmetadata.append(dict(zip(keys, metadata)))
        except: 
            print("ERROR!!!", filename)
    print("FILES:", counter)
    save_metadata(allmetadata, metadatafile, ordering, sorting)
    
main(collection, level, xpaths, ordering, sorting)
