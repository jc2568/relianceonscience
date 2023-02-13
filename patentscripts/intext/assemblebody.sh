#/bin/bash

### Author: Joshua Chu
### Date: January 12, 2023

### this script is a modification of a script copied from the /nplmatch/inputs/body/fulltext_2021j/
### directory and processes the files downloaded from Google for the annual update

### Command structure: sh assemblebody.sh


### input year from config file
year=$(perl $NPL_BASE/nplmatch/config.pl)

### set the inputs directory as a variable
directory=$(eval echo $NPL_BASE/nplmatch/inputs/intext)

### determine how many sub-directories are present in the year directory
numdir=$(find $directory/$year -mindepth 1 -maxdepth 1 -type d | wc -l)
subdir=$(printf "%03d\n" $numdir)

### crate the full path to the directory containing the files to be processed and directory for the
### processed files to be saved
fullpath="$directory/$year/$subdir/processed"
savepath="$directory/$year/$subdir/processed/fulltext"

echo "cat filtered files"
cat  $fullpath/filtered-* | sed -e 's/^__US0*/__US/' | sort -u > $savepath/bodynpl_digitized_ulc.tsv

echo "convert to lowercase"
cat $savepath/bodynpl_digitized_ulc.tsv | tr [:upper:] [:lower:] > $savepath/bodynpl_digitized_lc.tsv

chmod 777 $savepath/bodynpl_digitized_*
