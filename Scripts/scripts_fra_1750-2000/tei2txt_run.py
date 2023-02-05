"""
This file is used to adjust the settings and to run the 
extraction of plain text from XML-TEI files. 
"""

import tei2txt
from os.path import join


#=======================
# File paths (DO ADJUST)
#=======================

wdir = join("..", "data", "")
teipath = join(wdir, "xml", "20", "*.xml")
txtpath = join(wdir, "plain", "20", "")
modsfile = join(wdir, "tei2txt_mods.csv")


#=======================
# Parameters (DO ADJUST)
#=======================

head = False # Include chapter headings?
foreign = True # Include words marked as foreign?
note = False # Include text from footnotes?
pb = False # Include page breaks?
trailer = False # Include words marked as trailer?
quote = True # Include words marked as quote?
front = False # Include front matter?
back = False # Include back matter (other than notes)?

plaintext = True # Extract and save plain text?
modernize = False # Perform spelling modifications?
counts = False # Establish and save wordcounts?


# ======================
# Packaging (DON'T CHANGE)
# ======================

paths = {"teipath":teipath, "txtpath":txtpath, "modsfile":modsfile}
params = {"note":note, "head":head, "pb":pb, "foreign":foreign, "trailer":trailer, "front":front, "back":back, "quote":quote, "modernize":modernize, "counts":counts, "plaintext":plaintext}


#=======================
# Run tei2txt
#=======================

tei2txt.main(paths, params)
