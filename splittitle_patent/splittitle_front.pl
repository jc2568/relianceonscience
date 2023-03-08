#!/usr/local/bin/perl

require "$ENV{'NPL_BASE'}/nplmatch/config.pl";

$minlength=2;
$maxlength=100;

@Alphabet=("a","b","c","d","e","f","g","h","i","j","k","l","m",
           "n","o","p","q","r","s","t","u","v","w","x","y","z");

$skipfilepath="$NPL_MISC" . "skipwords";
open(SKIPFILE,"$skipfilepath")||die("Couldn't open skipwords file.\n");
while(<SKIPFILE>) {
    $word=$_;
    $word=~s/\s+//g;
    $SkipWord{$word}=1;
}
close(SKIPFILE);

$year=$ARGV[0];
$infile="$INPUTDIR_PATENTS_FRONT" . "front_$year" . ".tsv";
print "$infile\n";
#$infile="$INPUTDIR_PATENTS_FRONTBATCH" . "front_$year" . ".tsv";
#if (!$year) { die "Usage: splittitle_front.pl YEAR\n"; }
#
#open(INFILE,"$infile")||die("Can't open infile $infile.\n");
#
#$outdir="$NPL_BASE" . "/nplmatch/splittitle_patent/front/$year/";
#if (!(-e $outdir)) {
#    mkdir($outdir);
#    `chmod 777 $outdir`;
#}
#
## Create letter directories of the form 1976/a/b/ for a word like 'abridged' in order to
## avoid having too many files in a single directory.
#for($i=0;$i<26;$i++) {
#    $outdir_letter="$outdir" . "$Alphabet[$i]";
#    if (!(-e $outdir_letter)) {
#	mkdir($outdir_letter);
#        `chmod 777 $outdir_letter`;
#    }
#    for($j=0;$j<26;$j++) {
#	$outdir_letter="$outdir" . "$Alphabet[$i]" . "/" . "$Alphabet[$j]";
#	if (!(-e $outdir_letter)) {
#	    mkdir($outdir_letter);
#	    `chmod 777 $outdir_letter`;
#	}
#    }
#}
#
#$date=`date`;
#print "$date";
#
#$linect=0;
#while(<INFILE>) {
#    $line=$_;
#
#    $linect++;
#    if (($linect % 10000)==0) {
#	print "At line $linect\n";
#    }
#
#    # Drop the patent number
#    $rest=$line;
#    $rest=~s/[^\t]*\t//;
#
#    $rest=~tr/"-:;.,'/ /;
#
#    # Split the line up into words. 
#    # Notes: 
#    # Words like "N-Nitro-pyrazole" are split into 3 separate words.
#    # Something like "abc3defg" would be treated as "abcdefg"
#    # These calls might want to be changed; main thing is to do the same thing
#    # on both sides of the match.
#    @words="";
#    @words=split(/\s+/,$rest);
#    $prevword="";
#    foreach $word (sort(@words)) {
#	$word=~s/[^a-zA-Z]*//g;
#
#        # Avoid duplicates
#	if ($word eq $prevword) { next; } 
#
#	# Skip short and long words unless they are needed for a particular title
#	if ((length($word)<$minlength)||(length($word)>$maxlength)) {
#	    next; 
#	}
#
#	# Avoid very common words
#	if ($SkipWord{$word}) { next; }
#
#	$Output{$word}.=$line;
#	$prevword=$word;
#    }
#}
#close(INFILE);
#
#foreach $key (sort(keys %Output)) {
#    $firstletter=substr($key,0,1);
#    $secondletter=substr($key,1,1);
#    open(OUTFILE,">$outdir$firstletter/$secondletter/$key");
#    print OUTFILE "$Output{$key}";
#    close(OUTFILE);
#    `chmod 777 $outdir$firstletter/$secondletter/$key`;
#}
#
#$date=`date`;
#print "$date\n";
