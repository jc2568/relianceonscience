#/bin/bash

### Author: Joshua Chu
### Date: January 26, 2023

### this script is a modification of a script copied from the /nplmatch/inputs/body/fulltext_2021j/
### directory and processes the files downloaded from Google for the annual update

### Command structure: sh assemblebodybody.sh


### set the inputs directory as a variable
directory=$(eval echo $NPL_BASE/nplmatch/inputs/intext)

### creates full path to files
fullpath="$directory/googlefulltext"
savepath="$fullpath/fulltext"

TEMPFILE=./slurmfile.slurm

echo "cat filtered files and convert to lowercase"
echo "#!/bin/bash" > $TEMPFILE
echo "#SBATCH -p xlarge" >> $TEMPFILE
echo "#SBATCH -J AsBod" >> $TEMPFILE
echo "#SBATCH -t 12:00:00" >> $TEMPFILE
echo "#SBATCH --wckey=marxnfs1" >> $TEMPFILE
echo "module load perl5-libs" >> $TEMPFILE
echo "cat $fullpath/filtered-* | sed -e 's/^__US0*/__US/' | sort -u > $savepath/bodynpl_digitized_ulc.tsv" >> $TEMPFILE
echo "cat $savepath/bodynpl_digitized_ulc.tsv | tr [:upper:] [:lower:] > $savepath/bodynpl_digitized_lc.tsv" >> $TEMPFILE
echo "chmod 777 $savepath/bodynpl_digitized_*" >> $TEMPFILE

sbatch $TEMPFILE
sleep 0.1
