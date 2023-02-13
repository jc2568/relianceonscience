#!/bin/bash

### Author: Joshua Chu
### Date: December 15, 2022

### This script uses the convEpoNums.pl perl script to standardize the EPO numbers and the
### subsequent scripts will recognize the EPO numbers as patent numbers. The files will be
### saved in the raw directories but have the word 'mod' added to the name. This new file
### will look like EP0000000mod.txt and will be the file that the symbolic links are
### linked to.

### Author: Joshua Chu
### Edited: January 5, 2023

### The script was edited to work from the /nplmatch/inputs/patentscripts/intext directory and format
### EPO patent numbers to the USPTO patent number format. EPO input files can be found under the
### /inputs/intext/<current year> directory. The current year is obtained from the config.pl script.

### Command structure: sh slurm_convEpoNums.sh


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
fullintexteporaw="$directory/$frontorintext/$year/$subdir/epo_data/raw"

TEMPFILE=./slurmfile.slurm
NEPO=$(ls $fullintexteporaw/EP* | wc -l)
EP_ID=$(seq -f "%02g" 0 $((NEPO-1)))
array=($EP_ID)
a=0

echo "The number of EPO files to process is $NEPO"

 for i in $fullintexteporaw/EP*
 do
  echo "doing ${i:69:13}"
  echo "#!/bin/bash" > $TEMPFILE
  echo "#SBATCH -p small,large" >> $TEMPFILE
  echo "#SBATCH -J EPO-${array[${a}]}" >> $TEMPFILE
  echo "#SBATCH -t 12:00:00" >> $TEMPFILE
  echo "#SBATCH --wckey=marxnfs1" >> $TEMPFILE
  echo "" >> $TEMPFILE
  echo "module load perl5-libs" >>$TEMPFILE
  echo "perl $directory/patentscripts/intext/convEpoNums.pl < $i > $fullintexteporaw/EP${array[${a}]}00000mod.txt" >> $TEMPFILE
  echo "chmod 777 $fullintexteporaw/EP${array[${a}]}00000mod.txt" >> $TEMPFILE
  ((a++))
  sbatch $TEMPFILE
  sleep 0.1
 done
