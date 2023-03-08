#!/bin/bash

### Author: Joshua Chu
### Edited: January 27, 2023

### slurm script for the checkjtforempty.py script

### Command structure: sh slurm_checkjtforempty.sh


### input year from config file
year=$(perl $NPL_BASE/nplmatch/config.pl)

### set directory
directory=$(pwd)

### indicate to the script if the front or body directory
### is examined
frontorintext='body' # use front or body

### if searching the front directory, change 1800 to 1799
### if searching the body directory, change from 1799 to 1800
for ((i=1800; i<=$year; i++))
do
 TEMPFILE=./slurmfile.slurm
 echo "doing $i"
 echo "#!/bin/bash" > $TEMPFILE
 echo "#SBATCH -p xlarge" >> $TEMPFILE
 echo "#SBATCH -J ckjt$i" >> $TEMPFILE
 echo "#SBATCH -t 96:00:00" >> $TEMPFILE
 echo "#SBATCH --wckey=marxnfs1" >> $TEMPFILE
 echo "" >> $TEMPFILE
 echo "module load perl5-libs" >>$TEMPFILE
 echo "python3 $directory/checkjtforempty.py $i $frontorintext > ${frontorintext}_$i.tsv" >> $TEMPFILE
 sbatch $TEMPFILE
 sleep 0.1
done
