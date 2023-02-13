#!/bin/bash

### Author: Joshua Chu
### Date: January 24, 2023

### This script uses the cleanparas- files to identify a date and generate a 500-character window
### surrounding the date (typcially 250 upstream and downstream of the date). The config.pl file
### is not utilized to obtain the current year because the script extracts the year using the
### present working directory unix command. This enables the user to simply execute the command below
### without the worry of introducing user error into the script. Permissions are changed to 777.

### Command structure: sh slurm_parawindowsbatch.sh


### set the inputs directory as a variable
directory=$(eval echo $NPL_BASE/nplmatch/inputs)

### extracts intext from pwd
directory1=$(pwd)
frontorintext=${directory1:54}


### set the full paths to the paras- files for front and intext
fullpath="$directory/$frontorintext/googlefulltext"

TEMPFILE=./slurmfile.slurm
NCLNPARAS=$(ls $fullpath/cleanparas-* | wc -l)
CLNPARAS_ID=10001
echo ""
echo "The number of cleanparas- files to process is $NCLNPARAS"

for i in $fullpath/cleanparas-*
do
 s=$(eval echo ${i:62:20} | sed -e "s/\///")
 echo "doing $s"
 echo "#!/bin/bash" > $TEMPFILE
 echo "#SBATCH -p xlarge" >> $TEMPFILE
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
