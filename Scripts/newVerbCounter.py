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

with PySaxonProcessor(license=False) as proc:
  
    print(proc.version)
    xdmAtomicval = proc.make_boolean_value(False)
    xsltproc = proc.new_xslt30_processor()

# get the LIST list of verbs for REPO using script SCRIPT2 and output header
#    xsltproc.set_initial_match_selection(file_name=VERBFILE)
    xsltproc.set_parameter("lang",proc.make_string_value(REPO))
    xsltproc.set_parameter("list",proc.make_string_value(LIST))
    verbList= xsltproc.transform_to_string(source_file=VERBFILE, stylesheet_file=SCRIPT2)
# open the output file in write mode  
    output=open(OUTFILE,'w')
    header="textId year verbs innerVerbs "+verbList
    output.write(header)
    output.close()
    print("Wrote "+header+" to "+OUTFILE)
# reopen the output file in append mode  
    output=open(OUTFILE,'a')
# get the list of files to process from the DRIVERFILE  using SCRIPT0
#    fileList= xsltproc.transform_to_string(source_file=DRIVERFILE, stylesheet_file=SCRIPT0)
#    print(fileList)
# cycle through each file
    fileList="level2/NOR0055_Ragnhild_Rikka_Gan_tekst.xml,level2/NOR0056_Ragnhild_Fernanda_Mona_tekst.xml,level2/NOR0057_Normann_Krabvaag__tekst.xml,level2/NOR0059_Janson_De_Fredlose___Roman_fra_Reformationstiden_tekst.xml,level2/NOR0060_Jager_Syk_Kjerlihet_tekst.xml,level2/NOR0061_Jager_Fengsel_og_fortvilelse_tekst.xml,level2/NOR0063_Garborg_Eli_tekst.xml,level2/NOR0065_Bjornson_Synnove_Solbakken_tekst.xml,level2/NOR0066_Finne_Rachel_tekst.xml,level2/NOR0067_Riverton_Jernvognen_tekst_1.xml,level2/NOR0068_Undset_Vaaren_tekst_1.xml,level2/NOR0069_Undset_Jenny_tekst_1.xml,level2/NOR0070_KragTP_AdaWilde_tekst_1.xml,level2/NOR0071_Finne_Doktor_Wangs_børn_tekst_1.xml,level2/NOR0072_Dickmar_Psyche_tekst_1.xml,level2/NOR0073_Wexelsen_Et_Levnedsløb_tekst_1.xml,"
    for FILE in fileList.split(','):
      if len(FILE) <= 1 :
         exit()
      print("Processing "+FILE)
      NEXTFILE=REPOROOT+FILE
      xsltproc.set_parameter("lang",proc.make_string_value(REPO))
      xsltproc.set_parameter("verbString",proc.make_string_value(verbList.strip()))
# apply stylesheet to do the counting
      result = xsltproc.transform_to_string(source_file=NEXTFILE, stylesheet_file=SCRIPT1)
      output.write(result)
    output.close()
