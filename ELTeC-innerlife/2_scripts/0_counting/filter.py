import glob
import os
import sys
sys.path.append("/usr/lib/Saxon.C.API/python-saxon")
# import the Saxon/C library
import saxonc

repoRoot='/home/lou/Public/ELTeC-'

# does not work on deu or hun or rom for no reason that i can see (LB 2022-05-22)
# now looks for w elements anywhere in body, not just in chapters (LB 2021-03-21)
# Script to produce data for word embedding experiment (LB 2021-06-30)
# data produced is a blank delimited sequence of tokens 
# tokens may be w contents or @lemma values 
# only the content of divs of @type chapter is considered (see xslt for xpath)

if (len(sys.argv) <= 3) :
    print("Usage: python filter.py [lang] [pos] [wot]")
    print("  [lang] identifies input repository, which should be located at [repoRoot][lang]/level-2")
    print("  [pos] identifies filter and is either a single pos value e.g. 'NOUN' or 'CONTENT' which means 'NOUN|ADV|ADJ|VERB" ) 
    print("  [wot] indicates the output required and is either 'lemma' or 'form'") 
else :
    LANG=sys.argv[1]
    POS=sys.argv[2]
    WOT=sys.argv[3]
    SCRIPT=repoRoot+'data/Scripts/filter.xsl'
    OUTDIR=repoRoot+'data/'+LANG+'/'+POS+'/'+WOT+'/'
    repoName=repoRoot+LANG
    print("Filtering "+WOT+" from repo "+repoName+" for "+POS)
    os.chdir(repoName)
    FILES=sorted(glob.glob('level2/*.xml'))   
    with saxonc.PySaxonProcessor(license=False) as proc:
       print(proc.version)
       for FILE in FILES: 
             bf=os.path.splitext(FILE)[0] 
             f1=bf.split('/')[1]
             if ('_' in f1) :
                id=f1.split('_')[0]  
             else :
                id=f1.split(".")[0]
             FILE=repoName+"/"+FILE   
    # Initialize the XSLT 3.0. processor
             xsltproc = proc.new_xslt30_processor()
    # Default output directory     
             xsltproc.set_cwd(OUTDIR)
    # initialise XSLT 3.0 processor result
    # pass parameters
             xsltproc.set_parameter("pos",proc.make_string_value(POS))
             xsltproc.set_parameter("wot",proc.make_string_value(WOT))
             xsltproc.set_parameter("outDir",proc.make_string_value(OUTDIR))
    # apply stylesheet 
             result = xsltproc.transform_to_string(source_file=FILE, stylesheet_file=SCRIPT)
       
