import glob
import os
import sys
sys.path.append("/usr/lib/Saxon.C.API/python-saxon")
# import the Saxon/C library
import saxonc

repoRoot='/home/lou/Public/ELTeC-'
script='/home/lou/Public/Scripts/filter.xsl'

# Script to produce data for word embedding experiment (LB 2021-06-30)
 

if (len(sys.argv) <= 3) :
    print("Usage: python filter.py [lang] [pos] [wot]")
    print("  [lang] identifies input repository, which should be located at [repoRoot][lang]/level-2")
    print("  [pos] identifies filter and is either a single pos value e.g. 'NOUN' or 'CONTENT' which means 'NOUN|ADV|ADJ|VERB" ) 
    print("  [wot] indicates the output required and is either 'lemma' or 'form'") 
else :
    LANG=sys.argv[1]
    POS=sys.argv[2]
    WOT=sys.argv[3]
    repoName=repoRoot+LANG
    print("Filtering "+WOT+" from repo "+repoName+" for "+POS)
    os.chdir(repoName)
    FILES=sorted(glob.glob('level2/*.xml'))   
    with saxonc.PySaxonProcessor(license=False) as proc:
        print(proc.version)
        for FILE in FILES: 
             bf=os.path.splitext(FILE)[0] 
             f1=bf.split('/')[1]
             id=f1.split('_')[0]  
             FILE=repoName+"/"+FILE   
    #         print("File="+FILE+" id="+id)        
    # Initialize the XSLT 3.0. processor
             xsltproc = proc.new_xslt30_processor()
    # Default output directory
             xsltproc.set_cwd('/home/lou/Public/ELTeC-data/'+LANG+'/'+POS)
    # initialise XSLT 3.0 processor result
    #         xsltproc.set_result_as_raw_value(True)
             xsltproc.set_initial_match_selection(file_name=FILE)
             #pass parameters
             xsltproc.set_parameter("pos",proc.make_string_value(POS))
             xsltproc.set_parameter("wot",proc.make_string_value(WOT))
    # apply stylesheet 
             result = xsltproc.apply_templates_returning_file(stylesheet_file=script, output_file="ignore.me")
      
