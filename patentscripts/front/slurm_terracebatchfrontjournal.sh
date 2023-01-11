#!/bin/bash

### Author: Joshua Chu
### Edited: January 4, 2023

### this bash script creates multiple scripts that utilizes matchedjournals_magnameNODUPES.tsv as the input
### file and processes the data by calling the terracebatchfrontjournal.pl perl script. The output files
### are saved by year in the /inputs/front/googlebatchdownload/checkeveryjournal/journalbyrefyear directory

### Command structure: sh slurm_terracebatchjournal.sh


### this points to the config file and designates the annual update year
CURRENTYR=$(perl /home/fs01/nplmatchroot/nplmatch/config.pl)

### sets directories
directory=$(eval echo $NPL_BASE/nplmatch/inputs/front/googlebatchdownload/checkeveryjournal/journalbyrefyear)
directory1=$(eval echo $NPL_BASE/nplmatch/inputs)

TEMPFILE=./slurmfile.slurm

for ((i=1800; i<=$CURRENTYR; i++))
 do
 printf "doing $i\n"

 echo "#!/bin/bash" > $TEMPFILE
 echo "#SBATCH -p xlarge,large" >> $TEMPFILE
 echo "#SBATCH -J jou-${year}" >> $TEMPFILE
 echo "#SBATCH -t 12:00:00" >> $TEMPFILE
 echo "#SBATCH --wckey=marxnfs1" >> $TEMPFILE
 echo "" >> $TEMPFILE
 echo "module load perl5-libs" >>$TEMPFILE
 echo "cat $directory1/patentsfiles/matchedjournals_magnameNODUPES.tsv | perl $directory1/patentscripts/front/terracebatchfrontjournal.pl $i > $directory/journalfront_$i.tsv" >> $TEMPFILE
 echo "chmod 777 $directory/journalfront_$i.tsv" >> $TEMPFILE
 sbatch $TEMPFILE
done
