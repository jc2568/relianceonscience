#!/bin/bash

### Author: Joshua Chu
### Edited: January 12, 2023

### this script utilizes the splitjournal_body.pl perl script and separates
### journal names by year

### Command structure: sh slurm_splitjournal_body.sh


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
 echo "#SBATCH -J sjb$i" >> $TEMPFILE
 echo "#SBATCH -t 14-0" >> $TEMPFILE ### batch processing requires a larger time scale than just 96 hrs
 echo "#SBATCH --wckey=marxnfs1" >> $TEMPFILE
 echo "" >> $TEMPFILE
 echo "module load perl5-libs" >>$TEMPFILE
 echo "perl $directory/splitjournal_body.pl $i" >> $TEMPFILE
 sbatch $TEMPFILE
 sleep 0.1
done
