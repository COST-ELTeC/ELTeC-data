use strict; use warnings;

my ($LANG,$DATA,$LIST) = @ARGV;
if (not defined $LANG) { die "Language needed!"; }
if (not defined $DATA) { die "Where's the data?"; }
if (not defined $LIST) { die "List type needed: manual or  w2v ?"; }

my $debug=0;

my $ROOT='/home/lou/Public';
#my $DATA='VERB/lemma';
my $DIR="$ROOT/ELTeC-data/$LANG/$DATA";

# first get the list of inner verbs required
#my $wordList=`java -jar /usr/share/java/saxon9he.jar -s:$ROOT/ELTeC-data/innerVerbs.xml -xsl:$ROOT/ELTeC-data/Scripts/getVerbList.xsl lang=$LANG list=$LIST`;
my $targetList=`java -jar /usr/share/java/saxon9he.jar -s:$ROOT/ELTeC-data/innerVerbs.xml -xsl:$ROOT/ELTeC-data/Scripts/getTargets.xsl lang=$LANG list=$LIST`;

print("0textId year verbs innerVerbs ", $targetList,"\n");

# now process the available data for this language
# as created in previous step by the filter.py script
# the filename should match xxxxx_yyyy where 
#  xxxxx is the text id and yyyy is the year of publication
 

opendir(my $dh, $DIR) || die "$! $DIR" ;
while (readdir $dh) {
    my $fileName=$_;
    next if ($fileName =~ /^\./);
    $fileName  =~ /([^_]+)_(\d\d\d\d)/;
    print "Filename='$fileName'\n" if ($debug gt 0);
    my $textId=$1; my $year=$2;
    my $FILE = "$DIR/$fileName";
    print "Opening $FILE\n" if ($debug gt 0);
    open(IN, $FILE) || die "$! $FILE";
    my %lexicon=();
    my $verbs=0;
    my $innerVerbs=0;
# build a lexicon showing how often each term appears in one text
while (<IN>) {
    chop;
    my $string = $_;
    my @tokens = split / /,$string ;
    foreach my $token (@tokens) {
	$lexicon{$token} ++;
	$verbs ++;
    }
 }

# look up the count for the required words in the lexicon 
# and add it to the string
my $countString="";
my %catCounts =("",0);
my @targets = split(/ /,$targetList);
foreach my $target (@targets) {
    my ($token, $cat) = split(/:/,$target);
    my $count = $lexicon{$token};
    if (not($count)) {$count=0};
    $catCounts{$cat} += $count;
    print "added $count for $token = $cat\n" if ($debug gt 0);

    $countString .= "$count ";
    $innerVerbs += $count;
} # end of file

#foreach my $category (sort keys %catCounts) {
#    $countString .= $catCounts{$category};
#    $countString .= " ";


print "$textId $year $verbs $innerVerbs $countString\n";
}
