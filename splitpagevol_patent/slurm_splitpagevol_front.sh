#!/bin/bash

### Author: Joshua Chu
### Edited: January 9, 2023

### this script utilizes the splitpagevol_front.pl perl script and separates
### records according to the identified numbers in each line

### Command structure: sh slurm_splitpagevol_front.sh


### input year from config file
year=$(perl $NPL_BASE/nplmatch/config.pl)

### set the present working directory to variable
directory=$(pwd)

for ((i=1799; i<=$year; i++))
do
 TEMPFILE=./slurmfile.slurm
 echo "doing $i"
 echo "#!/bin/bash" > $TEMPFILE
 echo "#SBATCH -p xlarge" >> $TEMPFILE ### only use xlarge partition for patent step
 echo "#SBATCH -J spvf$i" >> $TEMPFILE
 echo "#SBATCH -t 14-0" >> $TEMPFILE ### leave time set to 14 days
 echo "#SBATCH --wckey=marxnfs1" >> $TEMPFILE
 echo "" >> $TEMPFILE
 echo "module load perl5-libs" >>$TEMPFILE
 echo "perl $directory/splitpagevol_front.pl $i" >> $TEMPFILE
 sbatch $TEMPFILE
 sleep 0.1
done
