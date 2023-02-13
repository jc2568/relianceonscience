#!/bin/bash

### Author: Joshua Chu
### Date: February 6, 2023

### this script utilizes the parsegrobidoutput.pl perl script to process the output files
### generated by the GROBID. The resulting output is saved as a single file called
### parsegrobidwindowoutput.txt in the /directory_grobid/directory_grobid_out directory.
### Two files are created from this .txt file: parsegrobidwindowoutput_ulc.txt and
### parsegrobidwindowoutput_lc.txt

### command structure: sh slurm_patwinoneline.sh


### input year from config file
year=$(perl $NPL_BASE/nplmatch/config.pl)

### crate the full path to the directory containing the files to be processed and directory for the
### processed files to be saved
grobidpath="$NPL_BASE/nplmatch/grobid"

echo "Are you doing an annual update or batch?"

read varname

if [[ $varname != "annual" ]] && [[ $varname != "batch" ]]
then
 echo "Please enter a valid option: <annual or batch>"

fi

if [[ $varname == "annual" ]]
then

 numdir=$(find $NPL_BASE/nplmatch/inputs/intext/$year -mindepth 1 -maxdepth 1 -type d | wc -l)
 subdir=$(printf "%03d\n" $numdir)

 inoutdir=$(eval echo $grobidpath/window/$year/directory_grobid/directory_grobid_out)

fi

if [[ $varname == "batch" ]]
then

 inoutdir=$(eval echo $grobidpath/window/grobidbatch/directory_grobid/directory_grobid_out)

fi

echo "The directory is: $inoutdir"

TEMPFILE=./slurmfile.slurm
NPARAS=$(ls $inoutdir/grobidwindowoutput-* | wc -l)
echo $NPARAS
PARAS_ID=10001

for i in $inoutdir/grobidwindowoutput-*
do
 echo "doing grobidwindowoutput-$PARAS_ID"

 perl $patentscripts/intext/parsegrobidoutput.pl $i >> $inoutdir/parsegrobidwindowoutput.txt

 ((PARAS_ID++))

done

chmod 777 $inoutdir/parsegrobidwindowoutput.txt

sort -u $inoutdir/parsegrobidwindowoutput.txt  > $inoutdir/parsegrobidwindowoutput_ulc.txt

cat $inoutdir/parsegrobidwindowoutput_ulc.txt | tr [:upper:] [:lower:] | sort -u > $inoutdir/parsegrobidwindowoutput_lc.txt
chmod 777 $inoutdir/parsegrobidwindowoutput_ulc.txt $inoutdir/parsegrobidwindowoutput_lc.txt
