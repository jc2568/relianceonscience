#!/bin/bash

### Author: Joshua Chu
### Date: December 15, 2022

### This script passes the windows- files to the frankenfilter.pl script in order to reduce the
### size of the windows. The config.pl is utilized to extract the year and determine how many
### subdirectories are present for the given year. The full path to the required files is
### programatically configured and the output files permissions are set for all user to have
### access.

### Command structure: sh slurm_npls.sh


### input year from config file
year=$(perl $NPL_BASE/nplmatch/config.pl)

### set the inputs directory as a variable
directory=$(eval echo $NPL_BASE/nplmatch/inputs)

### extract front or intext from the pwd; this will be utilized to construct the full directory paths
### in following steps
directory1=$(pwd)
frontorintext=${directory1:54}

### determine how many sub-directories are present in the year directory
numdir=$(find $directory/$frontorintext/$year -mindepth 1 -maxdepth 1 -type d | wc -l)
subdir=$(printf "%03d\n" $numdir)

### set the full paths to the paras- files for front and intext
fullpath="$directory/$frontorintext/$year/$subdir/processed"

TEMPFILE=./slurmfile.slurm
NWIN=$(ls $fullpath/windows-* | wc -l)
FILT_ID=10001

echo ""
echo "The number of windows- files to process is $NWIN"

for i in $fullpath/windows-*
do
 s=$(eval echo ${i:65:20} | sed -e "s/\///")
 echo "doing $s"
 echo "#!/bin/bash" > $TEMPFILE
 echo "#SBATCH -p small,large" >> $TEMPFILE
 echo "#SBATCH -J win$FILT_ID" >> $TEMPFILE
 echo "#SBATCH -t 12:00:00" >> $TEMPFILE
 echo "#SBATCH --wckey=marxnfs1" >> $TEMPFILE
 echo "module load perl5-libs" >> $TEMPFILE
 echo "perl $directory/patentscripts/$frontorintext/frankenfilter.pl $fullpath/windows-$FILT_ID > $fullpath/filtered-$FILT_ID 2> $fullpath/skipped-$FILT_ID" >> $TEMPFILE
 echo "chmod 777 $fullpath/filtered-$FILT_ID" >> $TEMPFILE
 echo "chmod 777 $fullpath/skipped-$FILT_ID" >> $TEMPFILE
 ((FILT_ID++))
 sbatch $TEMPFILE
 sleep 0.1
done
