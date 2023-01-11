#!/bin/bash

### Author: Joshua Chu
### Edited: January 9, 2023

### this bash script creates multiple scripts that utilizes matchedjournals_magnameNODUPES.tsv as the input
### file and processes the data by calling the terracefrontjournal.pl perl script. The output files are saved
### by year in the /inputs/front/yyyy/00#/processed/checkeveryjournal/journalbyrefyear directory

### Command structure: sh slurm_terracefrontjournal.sh


### import the year from the config.pl file and set variable to point to the googlebatchdownload directory
year=$(perl /home/fs01/nplmatchroot/nplmatch/config.pl)
yeardir=$(eval echo $NPL_BASE/nplmatch/inputs/front/2015)

### determine how many sub-directories are present in the year directory
numdir=$(find $yeardir/ -mindepth 1 -maxdepth 1 -type d | wc -l)
subdir=$(printf "%03d\n" $numdir)

### create full path
fullpath="$yeardir/$subdir/processed/checkeveryjournal/journalbyrefyear"
patfiles="$NPL_BASE/nplmatch/inputs/patentsfiles"
patscripts="$NPL_BASE/nplmatch/inputs/patentscripts"

TEMPFILE=./slurmfile.slurm

for ((i=1800; i<=$year; i++))
 do
 printf "doing $i\n"

 echo "#!/bin/bash" > $TEMPFILE
 echo "#SBATCH -p xlarge,large" >> $TEMPFILE
 echo "#SBATCH -J jou-${i}" >> $TEMPFILE
 echo "#SBATCH -t 12:00:00" >> $TEMPFILE
 echo "#SBATCH --wckey=marxnfs1" >> $TEMPFILE
 echo "" >> $TEMPFILE
 echo "module load perl5-libs" >>$TEMPFILE
 echo "cat $patfiles/matchedjournals_magnameNODUPES.tsv | perl $patscripts/front/terracefrontjournal.pl $i > $fullpath/journalfront_$i.tsv" >> $TEMPFILE
 echo "chmod 777 $fullpath/journalfront_$i.tsv" >> $TEMPFILE
 sbatch $TEMPFILE
done
