#!/bin/bash

### import the year from the config.pl file and set variable to point to the googlebatchdownload directory
year=$(perl /home/fs01/nplmatchroot/nplmatch/config.pl)
yeardir=$(eval echo $NPL_BASE/nplmatch/inputs/front/2015)

### determine how many sub-directories are present in the year directory
numdir=$(find $yeardir/ -mindepth 1 -maxdepth 1 -type d | wc -l)
subdir=$(printf "%03d\n" $numdir)

### create full path
fullpath="$yeardir/$subdir/processed"

cat $fullpath/cleanparas-100* | sort -u | tr [:upper:] [:lower:] | \
    perl $NPL_BASE/nplmatch/inputs/patentscripts/front/screenfrontjunk.pl > $fullpath/front$year\_clean.tsv

chmod 777 $fullpath/front$year\_clean.tsv
