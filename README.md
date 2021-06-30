# ELTeC-data
Contains data files extracted from level2 repositories for use in WG3 experiments using the `filter.py` script

## Organization
The repository contains one subdirectory for each language, containing all the datasets for that language. 
The following datasets are currently stored: 
- CONTENT : Extracts the lemmas for each word with a POS code NOUN ADJ ADV or VERB

## Filename and scope
The filename of the dataset contains the XML identifier of the source text followed by a code derived from its balance criteria. For example 'HU19018_T1FML.txt' is derived from the text with identifier `HU19018`, which is from timeslot 1, has a female author, is of medium length, and has a low reprint count.

## Generating other datasets
The Python3 script `filter.py` can be used to generate many more datasets. Once you have installed it, the Saxon/C library on which it depends, and the XSLT script `filter.xsl` which it invokes, you can run it at
the command line as follows:
~~~
python filter.py [lang] [pos] [wot]
~~~
- [lang] identifies the input repository. The script will look for ELTeC level 2 files here, more specifically at the location `repoRoot-[lang]/level-2` (where `repoRoot` is defined in the `filter.py` script) 
- [pos] identifies how to filter the input text and is either a single pos value e.g. 'NOUN', or 'CONTENT' which means 'NOUN|ADV|ADJ|VERB"  
- [wot] indicates the output required and is either 'lemma' (output the value of the @lemma attribute) or 'form' (output the content of the selected `<w>` element) 

The `filter.xsl` script selects from the input file only `<w>` elements which are contained by a `<div type='chapter'>`

The scripts are maintained in the ELTeC/Scripts repository


