# ELTeC-data
Contains data files extracted from level2 repositories for use in WG3 experiments using the `filter.py` script

## Organization
The repository contains one folder for each language, containing datasets specific to that language. 

The folder `Scripts` contains XSLT and Python code used to generate data.


The following datasets are currently stored: 
- `CONTENT` : text files (one per text) containing all lemmas for each word with a POS code NOUN ADJ ADV or VERB
- `verbFreqs.xml` : a list of lemmas with frequency counts in descending frequency order


## How to generate these datasets
###
#### verbCounter.py
This python script produces data to plot frequencies of "inner life verbs", as listed in the file `innerVerbs.xml`

The script is run at the command line as follows:

~~~
python verbCounter.py [lang] 
~~~

- [lang] identifies the input repository. The script will look for ELTeC level 2 files here, more specifically at the location `repoRoot-[lang]/level-2` (where `repoRoot` is defined in the `verbCounter.py` script) 

It produces a file called `ELTeC-data/[lang]/verbCounter.results, which can then be plotted with the R script `innerVerbs.R`

#### filter.py
The Python3 script `filter.py` generates datasets from level 2 encoded files. Once you have installed it, the Saxon/C library on which it depends, and the XSLT script `filter.xsl` which it invokes, you can run it at
the command line as follows:
~~~
python filter.py [lang] [pos] [wot]
~~~
- [lang] identifies the input repository. The script will look for ELTeC level 2 files here, more specifically at the location `repoRoot-[lang]/level-2` (where `repoRoot` is defined in the `filter.py` script) 
- [pos] identifies how to filter the input text and is either a single pos value e.g. 'NOUN', or 'CONTENT' which means 'NOUN|ADV|ADJ|VERB"  
- [wot] indicates the output required and is either 'lemma' (output the value of the @lemma attribute) or 'form' (output the content of the selected `<w>` element) 

The script writes a new folder called `[pos]` in the appropriate language folder, and creates within it a file listing each [wot] found in each text. It selects from the input file only `<w>` elements which are contained by a `<div type='chapter'>`. The filename of the dataset comprises the XML identifier of the source text followed by a code derived from its balance criteria. For example 'HU19018_T1FML.txt' is derived from the text with identifier `HU19018`, which is from timeslot 1, has a female author, is of medium length, and has a low reprint count.

#### verbFreq.xsl

The XSLT script `verbFreq.xsl` produces a list of all distinct lemmas marked with pos code `VERB` and their frequencies in the nominated corpus. Only lemmas with frequencies above 100 are listed,  in descending frequency order. 

To run it for corpus [xxx] use the following command line:
~~~~
saxon -xi [path]ELTeC-[xxx]/driver-2.tei verbFreq.xsl
~~~~
This will generate an XML file containing lines like this
~~~
<lemma form="beszél" freq="6890"/>
~~~
Output from this script is stored in a file called `verbFreqs.xml` in each language folder. 


#### verbCounter.py

The Python3 script `verbCounter.py` computes the relative frequencies of "inner-life" verbs in a specified language corpus over time. 


