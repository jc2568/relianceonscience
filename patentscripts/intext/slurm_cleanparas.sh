#!/bin/bash

### Author: Joshua Chu
### Date: December 15, 2022

### This script uses the soft-link files and 'clean' the files using the cleanparas.pl perl script. The
### config.pl file is not utilized to obtain the current year because the script extracts the year using
### the present working directory unix command. This enables the user to simply execute the command below
### without the worry of introducing user error into the script. Permissions are changed to 777.

### Author: Joshua Chu
### Edited: January 4, 2023

### The script was edited to work from the /nplmatch/inputs/patentscripts/{front or intext} directories
### and the current year is obtained from the config.pl file. This removes the requirement to copy scripts
### to newly created directories.

### Command structure: sh slurm_cleanparas.sh


### input year from config file
year=$(perl $NPL_BASE/nplmatch/config.pl)

### set the inputs directory as a variable
directory=$(eval echo $NPL_BASE/nplmatch/inputs)

### extract front or intext from the pwd; this will be utilized to construct the full directory paths
### in following steps
directory1=$(pwd)
frontorintext=${directory1:54}

### determine how many sub-directories are present in the year directory
numdir=$(find $directory/$frontorintext/2015 -mindepth 1 -maxdepth 1 -type d | wc -l)
subdir=$(printf "%03d\n" $numdir)

### set the full paths to the paras- files for front and intext
fullpath="$directory/$frontorintext/2015/$subdir/processed"

TEMPFILE=./slurmfile.slurm
NPARAS=$(ls $fullpath/paras-* | wc -l)
PARAS_ID=10001
echo ""
echo "The number of paras- files to process is $NPARAS"

for i in $fullpath/paras-*
do
 s=$(eval echo ${i:65:20} | sed -e "s/\///")
 echo "doing $s"
 echo "#!/bin/bash" > $TEMPFILE
 echo "#SBATCH -p small,large" >> $TEMPFILE
 echo "#SBATCH -J cln$PARAS_ID" >> $TEMPFILE
 echo "#SBATCH -t 12:00:00" >> $TEMPFILE
 echo "#SBATCH --wckey=marxnfs1" >> $TEMPFILE
 echo "" >> $TEMPFILE
 echo "module load perl5-libs" >>$TEMPFILE
 echo "perl $directory/patentscripts/$frontorintext/cleanparas.pl < $i > $fullpath/cleanparas-$PARAS_ID" >> $TEMPFILE
 echo "chmod 777 $fullpath/cleanparas-$PARAS_ID" >> $TEMPFILE
 ((PARAS_ID++))
 sbatch $TEMPFILE
 sleep 0.1
done
