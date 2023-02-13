#/bin/bash

### Author: Joshua Chu
### Date: January 9, 2023

### This script should be utilize to terrace the files for the annual update. It is
### important to note the user should have already created a symbolic link and
### executed the cleanparas.pl (or slurm_cleanparas.sh) script prior to executing
### this bash script. The input for this script are the cleanparas-10### files.

### Command structure: sh terracefrontyear.sh

### this points to the config file and designates the annual update year
year=$(perl /home/fs01/nplmatchroot/nplmatch/config.pl)

### sets the directory containing the required files
findpwd=$(pwd)
front=${findpwd:54}
yeardir=$(eval echo $NPL_BASE/nplmatch/inputs/$front/$year)
scripts=$(eval echo $NPL_BASE/nplmatch/inputs/patentscripts/front)

### determine how many sub-directories are present in the year directory
numdir=$(find $yeardir/ -mindepth 1 -maxdepth 1 -type d | wc -l)
subdir=$(printf "%03d\n" $numdir)

### constrcut the full path for directory
fullpath="$yeardir/$subdir/processed"

echo "screening for junk"
cat $fullpath/cleanparas-10* | sort -u | tr [:upper:] [:lower:] | perl $scripts/screenfrontjunk.pl >> $fullpath/$year.tsv
chmod 777 $fullpath/$year.tsv

echo "identifying citations with no years"
perl $scripts/frontnoyear.pl $fullpath/$year.tsv | grep '^__'  >> $fullpath/frontbyrefyear/front_1799.tsv
chmod 777 $fullpath/frontbyrefyear/front_1799.tsv

for ((i=1800; i<=$year; i++))
 do
 TEMPFILE=./slurmfile.slurm
 echo "terracing front files for year $i"
 echo "#!/bin/bash" > $TEMPFILE
 echo "#SBATCH -p small,large,xlarge" >> $TEMPFILE
 echo "#SBATCH -J ter$i" >> $TEMPFILE
 echo "#SBATCH -t 14-00:00" >> $TEMPFILE
 echo "#SBATCH --wckey=marxnfs1" >> $TEMPFILE
 echo "" >> $TEMPFILE
 echo "cat $fullpath/$year.tsv |  grep "[^a-z0-9\-]$i[^0-9\-]" > $fullpath/frontbyrefyear/front_$i.tsv" >> $TEMPFILE
 echo "chmod 777 $fullpath/frontbyrefyear/front_$i.tsv" >> $TEMPFILE
sbatch $TEMPFILE
sleep 0.1
done
