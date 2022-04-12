import pprint
import sys
sys.path.append("/home/lou/Downloads/libsaxon-HEC-11.3/Saxon.C.API/python-saxon")
#sys.path.append("/usr/lib/Saxon.C.API/python-saxon")
# import the Saxon/C library
from saxonc import *

HOME='/home/lou/Public/'

if (len(sys.argv) <= 2) :
    print("Usage: python verbCounter.py [repo] [list]")
    print("  [repo] identifies input repository, which should be located at [HOME]ELTEC-[repo]")
    print("  [list] identifies which list of verbs should be counted")
    print("         lists currently recognised are 'pure', 'noisy', 'w2v'")
    exit()

REPO=sys.argv[1]
LIST=sys.argv[2]
print("Inner verbs from "+ LIST + " list for "+REPO)
REPOROOT=HOME+'ELTeC-'+REPO+"/"
DRIVERFILE=REPOROOT+"driver-2.tei"
VERBFILE=HOME+'ELTeC-data/innerVerbs.xml'
SCRIPT0=HOME+'Scripts/posPipe/getFileNames.xsl'
SCRIPT1=HOME+'ELTeC-data/Scripts/verbCounter.xsl'
SCRIPT2=HOME+'ELTeC-data/Scripts/getVerbList.xsl'
OUTFILE=HOME+'ELTeC-data/'+REPO+'/verbCount_'+LIST+'.csv'

#with saxonc.PySaxonProcessor(license=False) as proc:
with PySaxonProcessor(license=False) as proc:
  
    print(proc.version)
    xsltproc = proc.new_xslt30_processor()
#    xsltproc.set_result_as_raw_value(True) 
# get the LIST list of verbs for REPO using script SCRIPT2 and output header
    xsltproc.set_initial_match_selection(file_name=VERBFILE)
    xsltproc.set_parameter("lang",proc.make_string_value(REPO))
    xsltproc.set_parameter("list",proc.make_string_value(LIST))
    verbList= xsltproc.apply_templates_returning_string(stylesheet_file=SCRIPT2)
# open the output file in write mode  
    output=open(OUTFILE,'w')
    header="textId year verbs innerVerbs "+verbList
    output.write(header)
    output.close()
    print("Wrote "+header+" to "+OUTFILE)
# reopen the output file in append mode  
    output=open(OUTFILE,'a')
# get the list of files to process from the DRIVERFILE  using SCRIPT0
    xsltproc.set_initial_match_selection(file_name=DRIVERFILE)
    fileList= xsltproc.apply_templates_returning_string(stylesheet_file=SCRIPT0)
# cycle through each file
    for FILE in fileList.split(','):
      if len(FILE) <= 1 :
         exit()
      print("Processing "+FILE)
      xsltproc.set_initial_match_selection(file_name=REPOROOT+FILE)
      xsltproc.set_parameter("lang",proc.make_string_value(REPO))
      xsltproc.set_parameter("verbString",proc.make_string_value(verbList.strip()))
# apply stylesheet to do the counting
      result = xsltproc.apply_templates_returning_string(stylesheet_file=SCRIPT1)
      output.write(result)
    output.close()
