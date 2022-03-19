# ELTeC-data
Contains data files extracted from level2 repositories for use in WG3 experiments using the `filter.py` script

## Organization
The repository contains one folder for each language, containing datasets specific to that language. 

The folder `Scripts` contains XSLT and Python code used to generate data.

The following datasets are currently stored: 
- `CONTENT` : text files (one per text) containing just the lemmas for each word with a POS code NOUN ADJ ADV or VERB
- `VERB` : text files (one per text) containing just the lemmas for each word with a POS code starting 'VERB'
- `verbFreqs.xml` : a list of lemmas with frequency counts in descending frequency order

By "lemmas" we mean strictly the content of the @lemma attribute, as it appears in the level2 file.


## How to generate these datasets
###

#### verbCounter.py

The Python3 script `verbCounter.py` computes the relative frequencies of "inner-life" verbs in a specified language corpus over time. 
The  "inner life verbs", are those listed in the file `innerVerbs.xml`, available in the ELTeC-data folder. This file contains several lists of target verbs to be counted, each associated with a language and a type.

The script is run at the command line as follows:
~~~
python verbCounter.py [lang] [which]
~~~

- [lang] identifies the input repository. The script will look for ELTeC level 2 files here, more specifically at the location `repoRoot-[lang]/level-2` (where `repoRoot` is defined in the `verbCounter.py` script)
- [which] specifies which type of verb list is to be used. Currently two types are recognised :
    - `manual` for verbs selected manually
    - `w2v` for verbs selected on the basis of a word2vec procedure 

It produces a file called `ELTeC-data/[lang]/verbCounter.[which].results`, in which each row contains 
- the text identifier
- the year of publication
- the total number of verbs in the text
- the total number of "inner verbs" in the text
- counts for each specified verb

Here for example is the start of the file produced by `python verbcounter.py eng manual`
~~~~
textId year verbs innerVerbs believe feel hear know like mean see seem think want 
ENG18450 1845 28087 1408 98 75 130 256 79 56 284 138 292 98
~~~~
An R script `innerVerbs.R` (written originally by Diana Santos) may be used to visualise this data as a series of boxplots.


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



