#!/bin/bash

### Author: Joshua Chu
### Edited: January 26, 2023

### this script utilizes the splittitle_body.pl perl script and separates
### title names by year

### Author: Joshua Chu
### Edited: January 27, 2023

### modified the #SBATCH -t flag from 12 to 96 hrs

### Command structure: sh slurm_splittitle_body.sh


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
 echo "#SBATCH -J stb$i" >> $TEMPFILE
 echo "#SBATCH -t 14-0" >> $TEMPFILE ### batch processing requires a larger time scale than just 96 hrs
 echo "#SBATCH --wckey=marxnfs1" >> $TEMPFILE
 echo "" >> $TEMPFILE
 echo "module load perl5-libs" >>$TEMPFILE
 echo "perl $directory/splittitle_body.pl $i" >> $TEMPFILE
 sbatch $TEMPFILE
 sleep 0.1
done
