$LANG='por';
$DATA='VERB/lemma';
$ROOT='/home/lou/Public';
$DIR="$ROOT/ELTeC-data/$LANG/$DATA";

# first get the list of inner verbs required
$wordList=`java -jar /usr/share/saxon/saxon9he.jar -s:$ROOT/ELTeC-data/innerVerbs.xml -xsl:$ROOT/ELTeC-data/Scripts/getVerbList.xsl lang=$LANG`;

print("textId year verbs innerVerbs ", $wordList,"\n");

# now loop around the verb data for each repo
opendir(my $dh, $DIR) || die "$! $DIR" ;
while (readdir $dh) {
    $fileName=$_;
    next if ($fileName =~ /^\./);
    $fileName  =~ /([^_]+)_(\d\d\d\d)/;
    $textId=$1; $year=$2;
    $FILE = "$DIR/$fileName";
#print "Opening $FILE\n";
    open(IN, $FILE) || die "$! $FILE";
    my %lexicon=();
    $verbs=0;
    $innerVerbs=0;
# build a lexicon showing how often each term appears in one text
while (<IN>) {
    chop;
    $string = $_;
    @tokens = split / /,$string ;
    foreach my $token (@tokens) {
	$lexicon{$token} ++;
	$verbs ++;
    }
 }

# look up the count for the required words in the lexicon

@innerVerbs = split(/ /,$wordList);
foreach my $inner (@innerVerbs) {
    $count = $lexicon{$inner};
    $countString .= "$count ";
    $innerVerbs += $count;
#    print "added $count for $inner\n";
}

print "$textId $year $verbs $innerVerbs $countString\n";
    $countString="";
}
