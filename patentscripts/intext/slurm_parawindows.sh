#!/bin/bash

### Author: Joshua Chu
### Date: December 15, 2022

### This script uses the cleanparas- files to identify a date and generate a 500-character window
### surrounding the date (typcially 250 upstream and downstream of the date). The config.pl file
### is not utilized to obtain the current year because the script extracts the year using the
### present working directory unix command. This enables the user to simply execute the command below
### without the worry of introducing user error into the script. Permissions are changed to 777.

### Command structure: sh slurm_parawindows.sh


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
fullpath="$directory/$frontorintext/$year/$subdir/processed"

TEMPFILE=./slurmfile.slurm
NCLNPARAS=$(ls $fullpath/cleanparas-* | wc -l)
CLNPARAS_ID=10001
echo ""
echo "The number of cleanparas- files to process is $NCLNPARAS"

for i in $fullpath/cleanparas-*
do
 s=$(eval echo ${i:65:20} | sed -e "s/\///")
 echo "doing $s"
 echo "#!/bin/bash" > $TEMPFILE
 echo "#SBATCH -p small" >> $TEMPFILE
 echo "#SBATCH -J win$CLNPARAS_ID" >> $TEMPFILE
 echo "#SBATCH -t 12:00:00" >> $TEMPFILE
 echo "#SBATCH --wckey=marxnfs1" >> $TEMPFILE
 echo "module load perl5-libs" >> $TEMPFILE
 echo "perl $directory/patentscripts/$frontorintext/parajustdumpyearwindows.pl $fullpath/cleanparas-$CLNPARAS_ID > $fullpath/windows-$CLNPARAS_ID" >> $TEMPFILE
 echo "chmod 777 $fullpath/windows-$CLNPARAS_ID" >> $TEMPFILE
 ((CLNPARAS_ID++))
 sbatch $TEMPFILE
 sleep 0.1
done
