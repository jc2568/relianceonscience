#!/bin/bash

### Author: Joshua Chu
### Date: January 4, 2023

### this script is a modification of a script copied from the /nplmatch/inputs/npl/checkeveryjournal
### directory and processes the batch files downloaded from Google.

### Command structure: sh checkjournalsbatchinlines.sh

### import the year from the config.pl file and set variable to point to the googlebatchdownload directory
year=$(perl /home/fs01/nplmatchroot/nplmatch/config.pl)
directory=$(eval echo $NPL_BASE/nplmatch/inputs/front/googlebatchdownload)

### the code below is a simple modification of the original code that uses the new directory structure. If
### the original code is required, navigate to the directory stated above
#grep "^j " $NPL_BASE/nplmatch/inputs/patentsfiles/journalsandabbrevsshortsortspace.tsv | \
#sed -e 's/ /\. /g' > $NPL_BASE/nplmatch/inputs/patentsfiles/journalsandabbrevspacedots.tsv
#chmod 777 $NPL_BASE/nplmatch/inputs/patentsfiles/journalsandabbrevspacedots.tsv
#
#cat $NPL_BASE/nplmatch/inputs/patentsfiles/journalsandabbrevsshortsortspace.tsv \
#    $NPL_BASE/nplmatch/inputs/patentsfiles/journalsandabbrevspacedots.tsv \
#    $NPL_BASE/nplmatch/inputs/patentsfiles/magjournalabbrevs.tsv | \
#    sort -u | tr [:upper:] [:lower:] > $NPL_BASE/nplmatch/inputs/patentsfiles/journalsandabbrevswithspacetogrep.tsv
#chmod 777 $NPL_BASE/nplmatch/inputs/patentsfiles/journalsandabbrevswithspacetogrep.tsv
#
#cat $directory/frontbatch$year\_clean.tsv  | sort -u | fgrep --color=always -f $NPL_BASE/nplmatch/inputs/patentsfiles/journalsandabbrevswithspacetogrep.tsv | \
#    sort -u > $NPL_BASE/nplmatch/inputs/patentsfiles/matchedjournalscolorwithspace.tsv
#
#cat $directory/frontbatch$year\_clean.tsv  | sort -u | fgrep --color=always -f $NPL_BASE/nplmatch/inputs/patentsfiles/journalsandabbrevsnospacetogrep.tsv | \
#    sort -u > $NPL_BASE/nplmatch/inputs/patentsfiles/matchedjournalscolornospace.tsv
#chmod 777 $NPL_BASE/nplmatch/inputs/patentsfiles/matchedjournalscolorwithspace.tsv
#chmod 777 $NPL_BASE/nplmatch/inputs/patentsfiles/matchedjournalscolornospace.tsv
#
#cat $NPL_BASE/nplmatch/inputs/patentsfiles/matchedjournalscolorwithspace.tsv $NPL_BASE/nplmatch/inputs/patentsfiles/matchedjournalscolornospace.tsv | tr [:upper:] [:lower:] | \
#    sort -u > $NPL_BASE/nplmatch/inputs/patentsfiles/matchedjournalscolor.tsv
#chmod 777 $NPL_BASE/nplmatch/inputs/patentsfiles/matchedjournalscolor.tsv

#perl $NPL_BASE/nplmatch/inputs/patentscripts/front/matchjournalabbrevstomagname.pl
#chmod 777 $NPL_BASE/nplmatch/inputs/patentsfiles/matchedjournals_magname.tsv

sort -u $NPL_BASE/nplmatch/inputs/patentsfiles/matchedjournals_magname.tsv > $NPL_BASE/nplmatch/inputs/patentsfiles/matchedjournals_magnameNODUPES.tsv
chmod 777 $NPL_BASE/nplmatch/inputs/patentsfiles/matchedjournals_magnameNODUPES.tsv
