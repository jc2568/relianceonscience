#!/bin/bash

### Author: Joshua Chu
### Date: January 26, 2023

### this script is a modification of a script copied from the /nplmatch/inputs/npl/checkeveryjournal
### directory and processes the files downloaded from Google for the annual update

### Command structure: sh checkjournalsinlinesbatch.sh


### set the inputs directory as a variable
directory=$(eval echo $NPL_BASE/nplmatch/inputs/intext)

### crate the full path to the directory containing the files to be processed
fullpath="$directory/googlefulltext/fulltext"
grobid="$NPL_BASE/nplmatch/grobid/window/grobidbatch/directory_grobid/directory_grobid_out"

if [[ -f "$grobid/parsegrobidwindowoutput_lc.txt" ]] && [[ -f "$grobid/parsegrobidwindowoutput_ulc.txt" ]]; then
    echo "The files parsegrobidwindowoutput_lc.txt and parsegrobidwindowoutput_ulc.txt exist"

else
    echo "One of the parsegrobidwindowoutput_lc.txt and parsegrobidwindowoutput_ulc.txt files does not exist in the"
    echo "$grobid directory"
    echo ""
    echo "Return to the GROBID section in the protocol to ensure these files are generated"

fi

### created when doing front but code here just in case
#cat ./journalsandabbrevsshortsortspace.tsv ./journalsandabbrevspacedots.tsv ./magjournalabbrevs.tsv | sort -u > ./journalsandabbrevswithspacetogrep.tsv

## removes the files that was previously created because the front files utilize the same files
rm $NPL_BASE/nplmatch/inputs/patentsfiles/matchedjournalscolorwithspace.tsv
rm $NPL_BASE/nplmatch/inputs/patentsfiles/matchedjournalscolornospace.tsv
rm $NPL_BASE/nplmatch/inputs/patentsfiles/matchedjournalscolor.tsv
rm $NPL_BASE/nplmatch/inputs/patentsfiles/matchedjournals_magname.tsv
rm $NPL_BASE/nplmatch/inputs/patentsfiles/matchedjournals_magnameNODUPES.tsv


### these must be recreated because the front will overwrite if the front citations were
### processed before the body
cat $fullpath/bodynpl_digitized_lc.tsv $grobid/parsegrobidwindowoutput_lc.txt | fgrep --color=always -f $NPL_BASE/nplmatch/inputs/patentsfiles/journalsandabbrevswithspacetogrep.tsv | \
    sort -u > $NPL_BASE/nplmatch/inputs/patentsfiles/matchedjournalscolorwithspace.tsv

cat $fullpath/bodynpl_digitized_ulc.tsv $grobid/parsegrobidwindowoutput_ulc.txt | fgrep --color=always -f $NPL_BASE/nplmatch/inputs/patentsfiles/journalsandabbrevsnospacetogrep.tsv | \
    sort -u > $NPL_BASE/nplmatch/inputs/patentsfiles/matchedjournalscolornospace.tsv

cat $NPL_BASE/nplmatch/inputs/patentsfiles/matchedjournalscolorwithspace.tsv $NPL_BASE/nplmatch/inputs/patentsfiles/matchedjournalscolornospace.tsv | \
    tr [:upper:] [:lower:] | sort -u > $NPL_BASE/nplmatch/inputs/patentsfiles/matchedjournalscolor.tsv
chmod 777 $NPL_BASE/nplmatch/inputs/patentsfiles/*

printf "Executing matchjournalabbrevstomagname perl script\n"
perl ./matchjournalabbrevstomagname.pl
chmod 777 $NPL_BASE/nplmatch/inputs/patentsfiles/matchedjournals_magname.tsv

printf "Constructing matchedjournals_magnameNODUPES.tsv file\n"
cat $NPL_BASE/nplmatch/inputs/patentsfiles/matchedjournals_magname.tsv | sort -u > $NPL_BASE/nplmatch/inputs/patentsfiles/matchedjournals_magnameNODUPES.tsv
chmod 777 $NPL_BASE/nplmatch/inputs/patentsfiles/matchedjournals_magnameNODUPES.tsv
