#!/bin/bash

### Author: Joshua Chu
### Edited: January 26, 2023

### this script utilizes the splitpagevol_body.pl perl script and separates
### records according to the identified numbers in each line

### Author: Joshua Chu
### Edited: January 26, 2023

### changed the -t flag to accommodate large processing times

### Command structure: sh slurm_splitpagevol_body.sh


### input year from config file
year=$(perl $NPL_BASE/nplmatch/config.pl)

### set the present working directory to variable
directory=$(pwd)

for ((i=1800; i<=$year; i++))
do
 TEMPFILE=./slurmfile.slurm
 echo "doing $i"
 echo "#!/bin/bash" > $TEMPFILE
 echo "#SBATCH -p xlarge" >> $TEMPFILE ### only use xlarge partition for patent step
 echo "#SBATCH -J spvb$i" >> $TEMPFILE
 echo "#SBATCH -t 14-0" >> $TEMPFILE ### leave time set to 14 days
 echo "#SBATCH --wckey=marxnfs1" >> $TEMPFILE
 echo "" >> $TEMPFILE
 echo "module load perl5-libs" >>$TEMPFILE
 echo "perl $directory/splitpagevol_body.pl $i" >> $TEMPFILE
 sbatch $TEMPFILE
 sleep 0.1
done

