#/bin/bash

### Author: Joshua Chu
### Date: January 3, 2023

### This script terraces the bulk Google front downloads only. Attempting to use this
### script for the annual update will result in failure. It is important to note the
### user should have already created a symbolic link and executed the cleanparas.pl
### (or slurm_cleanparas.sh) script prior to executing this bash script. The input for
### this script is the cleanparas-10001 file.

### Command structure: sh terracebatchfrontyear.sh

### this points to the config file and designates the annual update year
CURRENTYR=$(perl /home/fs01/nplmatchroot/nplmatch/config.pl)

### sets the directory containing the required files
findpwd=$(pwd)
front=${findpwd:54}
googleDir=$(eval echo $NPL_BASE/nplmatch/inputs/$front/googlebatchdownload)

### checks for the frontbyrefyear directory
if [ -d "$googleDir/frontbyrefyear/" ]
then
 echo "The $googleDir/frontbyrefyear/ directory exists"

else
 echo "The $googleDir/frontbyrefyear/ directory does not exists and was created"
 mkdir $googleDir/frontbyrefyear/
 chmod 777 $googleDir/frontbyrefyear/
fi

if [ -d "$googleDir/checkeveryjournal/journalbyrefyear/" ]
then
 echo "The $googleDir/checkeveryjournal/journalbyrefyear/ directory exists"

else
 echo "The $googleDir/checkeveryjournal/journalbyrefyear/ directory does not exists and was created"
 mkdir -p $googleDir/checkeveryjournal/journalbyrefyear/
 chmod 777 $googleDir/checkeveryjournal/
 chmod 777 $googleDir/checkeveryjournal/journalbyrefyear/
fi

echo "screening for junk"
cat $googleDir/cleanparas-10* | sort -u | tr [:upper:] [:lower:] | perl screenfrontjunk.pl >> $googleDir/googlebatchand$CURRENTYR.tsv
chmod 777 $googleDir/googlebatchand$CURRENTYR.tsv

echo "identifying citations with no years"
perl frontnoyear.pl $googleDir/googlebatchand$CURRENTYR.tsv | grep '^__'  >> $googleDir/frontbyrefyear/front_1799.tsv
chmod 777 $googleDir/frontbyrefyear/front_1799.tsv

for ((i=1800; i<=$CURRENTYR; i++))
 do
 TEMPFILE=./slurmfile.slurm
 echo "terracing front files for year $i"
 echo "#!/bin/bash" > $TEMPFILE
 echo "#SBATCH -p small,large,xlarge" >> $TEMPFILE
 echo "#SBATCH -J ter$i" >> $TEMPFILE
 echo "#SBATCH -t 14-00:00" >> $TEMPFILE
 echo "#SBATCH --wckey=marxnfs1" >> $TEMPFILE
 echo "" >> $TEMPFILE
 echo "cat $googleDir/googlebatchand$CURRENTYR.tsv |  grep "[^a-z0-9\-]$i[^0-9\-]" > $googleDir/frontbyrefyear/front_$i.tsv" >> $TEMPFILE
 echo "chmod 777 $googleDir/frontbyrefyear/front_$i.tsv" >> $TEMPFILE
sbatch $TEMPFILE
sleep 0.1
done
