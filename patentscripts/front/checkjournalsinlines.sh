#!/bin/bash

### Author: Joshua Chu
### Date: January 9, 2023

### this script is a modification of a script copied from the /nplmatch/inputs/npl/checkeveryjournal
### directory and processes the files downloaded from Google for the annual update

### Command structure: sh checkjournalsinlines.sh

### import the year from the config.pl file and set variable to point to the googlebatchdownload directory
year=$(perl /home/fs01/nplmatchroot/nplmatch/config.pl)
yeardir=$(eval echo $NPL_BASE/nplmatch/inputs/front/2015)

### determine how many sub-directories are present in the year directory
numdir=$(find $yeardir/ -mindepth 1 -maxdepth 1 -type d | wc -l)
subdir=$(printf "%03d\n" $numdir)

### create full path
fullpath="$yeardir/$subdir/processed"


###### THIS BLOCK OF CODE DOES NOT NEED TO BE REPEATED ######
### the code below is a simple modification of the original code that uses the new directory structure. If
### the original code is required, navigate to the directory stated above
#grep "^j " $NPL_BASE/nplmatch/inputs/patentsfiles/journalsandabbrevsshortsortspace.tsv | \
#sed -e 's/ /\. /g' > $NPL_BASE/nplmatch/inputs/patentsfiles/journalsandabbrevspacedots.tsv
#chmod 777 $NPL_BASE/nplmatch/inputs/patentsfiles/journalsandabbrevspacedots.tsv

#cat $NPL_BASE/nplmatch/inputs/patentsfiles/journalsandabbrevsshortsortspace.tsv \
#    $NPL_BASE/nplmatch/inputs/patentsfiles/journalsandabbrevspacedots.tsv \
#    $NPL_BASE/nplmatch/inputs/patentsfiles/magjournalabbrevs.tsv | \
#    sort -u | tr [:upper:] [:lower:] > $NPL_BASE/nplmatch/inputs/patentsfiles/journalsandabbrevswithspacetogrep.tsv
#chmod 777 $NPL_BASE/nplmatch/inputs/patentsfiles/journalsandabbrevswithspacetogrep.tsv


rm $NPL_BASE/nplmatch/inputs/patentsfiles/matchedjournalscolorwithspace.tsv
rm $NPL_BASE/nplmatch/inputs/patentsfiles/matchedjournalscolornospace.tsv
rm $NPL_BASE/nplmatch/inputs/patentsfiles/matchedjournalscolor.tsv
rm $NPL_BASE/nplmatch/inputs/patentsfiles/matchedjournals_magname.tsv
rm $NPL_BASE/nplmatch/inputs/patentsfiles/matchedjournals_magnameNODUPES.tsv

cat $fullpath/front$year\_clean.tsv  | sort -u | fgrep --color=always -f $NPL_BASE/nplmatch/inputs/patentsfiles/journalsandabbrevswithspacetogrep.tsv | \
    sort -u > $NPL_BASE/nplmatch/inputs/patentsfiles/matchedjournalscolorwithspace.tsv

cat $fullpath/front$year\_clean.tsv  | sort -u | fgrep --color=always -f $NPL_BASE/nplmatch/inputs/patentsfiles/journalsandabbrevsnospacetogrep.tsv | \
    sort -u > $NPL_BASE/nplmatch/inputs/patentsfiles/matchedjournalscolornospace.tsv
chmod 777 $NPL_BASE/nplmatch/inputs/patentsfiles/matchedjournalscolorwithspace.tsv
chmod 777 $NPL_BASE/nplmatch/inputs/patentsfiles/matchedjournalscolornospace.tsv

cat $NPL_BASE/nplmatch/inputs/patentsfiles/matchedjournalscolorwithspace.tsv $NPL_BASE/nplmatch/inputs/patentsfiles/matchedjournalscolornospace.tsv | tr [:upper:] [:lower:] | \
    sort -u > $NPL_BASE/nplmatch/inputs/patentsfiles/matchedjournalscolor.tsv
chmod 777 $NPL_BASE/nplmatch/inputs/patentsfiles/matchedjournalscolor.tsv

perl $NPL_BASE/nplmatch/inputs/patentscripts/front/matchjournalabbrevstomagname.pl
chmod 777 $NPL_BASE/nplmatch/inputs/patentsfiles/matchedjournals_magname.tsv

sort -u $NPL_BASE/nplmatch/inputs/patentsfiles/matchedjournals_magname.tsv > $NPL_BASE/nplmatch/inputs/patentsfiles/matchedjournals_magnameNODUPES.tsv
chmod 777 $NPL_BASE/nplmatch/inputs/patentsfiles/matchedjournals_magnameNODUPES.tsv
