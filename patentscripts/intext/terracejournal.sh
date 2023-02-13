#!/bin/bash


### Author: Joshua Chu
### Date: January 12, 2023

### this script is a modification of a script copied from the /nplmatch/inputs/body/fulltext_2021j/
### directory and processes the files downloaded from Google for the annual update

### Command structure: sh terracejournal.sh


### input year from config file
year=$(perl $NPL_BASE/nplmatch/config.pl)

### set the inputs directory as a variable
directory=$(eval echo $NPL_BASE/nplmatch/inputs/intext)

### determine how many sub-directories are present in the year directory
numdir=$(find $directory/$year -mindepth 1 -maxdepth 1 -type d | wc -l)
subdir=$(printf "%03d\n" $numdir)

### crate the full path to the directory containing the files to be processed and directory for the
### processed files to be saved
miscpath="$NPL_BASE/nplmatch/inputs/patentsfiles"
savepath="$directory/$year/$subdir/processed/checkeveryjournal/journalbodybyrefyear"

### when creating this script, slurm was tied up and the server had to be used to run the script. If
### you want to use slurm uncomment the sections below and then comment out the first cat command
TEMPFILE=./slurmFile.slurm

for ((i=1800; i<=$year; i++))
do
 echo "$i"
# cat $miscpath/matchedjournals_magnameNODUPES.tsv | perl ./terracenpl.pl $i > $savepath/journalbody_$i.tsv

 echo "#!/bin/bash" > $TEMPFILE
 echo "#SBATCH -p large" >> $TEMPFILE
 echo "#SBATCH -J tbjb-${year}" >> $TEMPFILE
 echo "#SBATCH -t 12:00:00" >> $TEMPFILE
 echo "#SBATCH --wckey=marxnfs1" >> $TEMPFILE
 echo "" >> $TEMPFILE
 echo "module load perl5-libs" >>$TEMPFILE
 echo "cat $miscpath/matchedjournals_magnameNODUPES.tsv | perl ./terracenpl.pl $i > $savepath/journalbody_$year.tsv" >> $TEMPFILE
 echo "chmod 777 $savepath/body_$i.tsv" >> $TEMPFILE
 sbatch $TEMPFILE

done

#chmod 777 $savepath/*
