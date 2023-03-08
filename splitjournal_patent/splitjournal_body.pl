#!/usr/local/bin/perl

require "$ENV{'NPL_BASE'}/nplmatch/config.pl";

$basedir="$NPL_BASE"."/nplmatch/splitjournal_patent/body/";
if (!(-e $basedir)) { 
    die("Base Directory $basedir does not exist.\n");
}

@Alphabet=("a","b","c","d","e","f","g","h","i","j","k","l","m",
           "n","o","p","q","r","s","t","u","v","w","x","y","z","_");

$year=$ARGV[0];
if (!$year) { die "Usage: splitjournal_body.pl YEAR\n"; }

#$infile="$INPUTDIR_JOURNAL_BODY" . "journalbody_$year" . ".tsv";
$infile="$INPUTDIR_JOURNAL_BODYBATCH" . "journalbody_$year" . ".tsv";
open(INFILE,"$infile")||die("Can't open infile $infile.\n");

$outdir="$basedir"."$year";
if (!(-e $outdir)) {
    mkdir($outdir);
    `chmod 777 $outdir`;
}

# Create letter directories of the form 1976/p/r/ for a journal like 'proceedings of the nas' in order to
# avoid having too many files in a single directory.  There still may be a lot in this case.
for($i=0;$i<27;$i++) {
    $outdir_letter="$outdir"."/"."$Alphabet[$i]";
    if (!(-e $outdir_letter)) {
	mkdir($outdir_letter);
        `chmod 777 $outdir_letter`;
    }
    for($j=0;$j<27;$j++) {
	$outdir_letter="$outdir"."/"."$Alphabet[$i]"."/"."$Alphabet[$j]";
	if (!(-e $outdir_letter)) {
	    mkdir($outdir_letter);
	    `chmod 777 $outdir_letter`;
	}
    }
}

$date=`date`;
print "Began on: $date";

$linect=0;
while(<INFILE>) {
    $line=$_;

    $linect++;
    if (($linect % 10000)==0) {
	print "At line $linect\n";
    }
    $line=~s/\n//;
    ($journal,$patent,$npl)=split(/\t/,$line);

    $outputline="$patent\t$npl\n";

    # In journal name, replace spaces with underscores and then drop all non alphanumerics from journal name except for underscore.
    # Must do this on the MAG/WOS/PUBMED end of things as well so that they match.
    $journal=~s/ /_/g;
    $journal=~s/\W//g;
    $Output{$journal}.=$outputline;
    
    if (!$journal) {
	print "ERROR with line $line\n";
    }

}
close(INFILE);

foreach $key (sort(keys %Output)) {
    $firstletter=substr($key,0,1);
    $secondletter=substr($key,1,1);
    if ((!$firstletter)||(!$secondletter)||(!$key)) { next; }
    open(OUTFILE,">$outdir/$firstletter/$secondletter/$key");
    print OUTFILE "$Output{$key}";
    close(OUTFILE);
    `chmod 777 $outdir/$firstletter/$secondletter/$key`;
}

$date=`date`;
print "Finished on: $date\n";
