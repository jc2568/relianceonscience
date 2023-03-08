#!/usr/local/bin/perl

require "$ENV{'NPL_BASE'}/nplmatch/config.pl";

$maxnumber="100000";

$year=$ARGV[0];
#$infile="$INPUTDIR_PATENTS_FRONT" . "front_$year" . ".tsv";
$infile="$INPUTDIR_PATENTS_FRONTBATCH" . "front_$year" . ".tsv";
if (!$year) { die "Usage: splitpagevol_front.pl YEAR\n"; }

open(INFILE,"$infile")||die("Can't open infile $infile.\n");

$outdir="$NPL_BASE" . "/nplmatch/splitpagevol_patent/front/$year" . "/";

if (!(-e $outdir)) {
    mkdir($outdir);
    `chmod 777 $outdir`;

    for($i=0;$i<10;$i++) {
	$dirname="$outdir" . "$i";
	if (!(-e $dirname)) {
	    mkdir($dirname);
	    `chmod 777 $dirname`;
	}
    }
}

$date=`date`;
print "$date";

$linect=0;
while(<INFILE>) {
    $line=$_;

    $linect++;
    if (($linect % 10000)==0) {
	print "At line $linect\n";
    }

    # Drop the patent number
    $rest=$line;
    $rest=~s/[^\t]*\t//;

    $rest=~s/[^0-9]$year[^0-9]//; # Drop one instance of the year 

    # Make an array of all the numbers remaining in the line.
    $rest=~s/[^0-9]/ /g; 
    $rest=~s/^\s+//;
    @numbers="";
    @numbers=split(/\s+/,$rest);
    @numbers = sort { $a <=> $b } @numbers;

    # Append this line to the file for each number referenced.
    $prevnumber=10000000;
    foreach $number (@numbers) {
	if ($number==$prevnumber) { next; }
	if ($number>$maxnumber) { next; }
	$Output{$number}.=$line;
    }
}

foreach $key (keys %Output) {
    $firstchar=substr($key,0,1);
    open(OUTFILE,">$outdir/$firstchar/$key")||die("can't open file $outdir/$firstchar/$key<\n");
    print OUTFILE "$Output{$key}";
    close(OUTFILE);
    `chmod 777 $outdir/$firstchar/$key`;
}

$date=`date`;
print "$date\n";
