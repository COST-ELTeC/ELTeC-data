import pprint
import sys
sys.path.append("/usr/lib/Saxon.C.API/python-saxon")
# import the Saxon/C library
import saxonc

HOME='/home/lou/Public/'

if (len(sys.argv) <= 1) :
    print("Usage: python verbCounter.py [repo]")
    print("  [repo] identifies input repository, which should be located at [HOME]ELTEC-[repo]")
    exit()

REPO=sys.argv[1]
print("Looking for repo "+REPO)
REPOROOT=HOME+'ELTeC-'+REPO+"/"
DRIVERFILE=REPOROOT+"driver-2.tei"
SCRIPT0=HOME+'Scripts/posPipe/getFileNames.xsl'
SCRIPT1=HOME+'ELTeC-data/verbCounter.xsl'
OUTFILE=HOME+'ELTeC-data/'+REPO+'/verbCounter.results'
output=open(OUTFILE,'w')
output.write('<listPoints>')
with saxonc.PySaxonProcessor(license=False) as proc:
    # re open the output file in append mode  
    output=open(OUTFILE,'a')
    print(proc.version)
    xsltproc = proc.new_xslt30_processor()
    xsltproc.set_result_as_raw_value(True) 
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
# apply stylesheet to do the counting
      result = xsltproc.apply_templates_returning_string(stylesheet_file=SCRIPT1)
      output.write(result)
    output.close()
output=open(OUTFILE,'a')
output.write('</listPoints>')
output.close()    