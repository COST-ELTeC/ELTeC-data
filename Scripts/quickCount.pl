use strict; use warnings;

my ($LANG,$LIST) = @ARGV;
if (not defined $LANG) { die "Language needed!"; }
if (not defined $LIST) { die "Pure, noisy, or w2v ?"; }


my $DATA='VERB/lemma';
#my $DATA='VERB';
my $ROOT='/home/lou/Public';
my $DIR="$ROOT/ELTeC-data/$LANG/$DATA";

# first get the list of inner verbs required
my $wordList=`java -jar /usr/share/java/saxon9he.jar -s:$ROOT/ELTeC-data/innerVerbs.xml -xsl:$ROOT/ELTeC-data/Scripts/getVerbList.xsl lang=$LANG list=$LIST`;

print("0textId year verbs innerVerbs ", $wordList,"\n");

# now loop around the verb data for each repo
# (created in previous step by the filter.py script)

opendir(my $dh, $DIR) || die "$! $DIR" ;
while (readdir $dh) {
    my $fileName=$_;
    next if ($fileName =~ /^\./);
    $fileName  =~ /([^_]+)_(\d\d\d\d)/;
#    $fileName  =~ /([^_]+)_(.....)/;
#    print "Filename='$fileName'\n";
    my $textId=$1; my $year=$2;
    my $FILE = "$DIR/$fileName";
#print "Opening $FILE\n";
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
    my $countString="";
my @innerVerbs = split(/ /,$wordList);
foreach my $inner (@innerVerbs) {
    my $count = $lexicon{$inner};
    if (not($count)) {$count=0};
    $countString .= "$count ";
    $innerVerbs += $count;
#    print "added $count for $inner\n";
}

print "$textId $year $verbs $innerVerbs $countString\n";
}
