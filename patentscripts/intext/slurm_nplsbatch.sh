#!/bin/bash

### Author: Joshua Chu
### Date: January 24, 2023

### This script passes the windows- files to the frankenfilter.pl script in order to reduce the
### size of the windows. The config.pl is not utilized because this is a batch script used
### to process all files found in the /inputs/intext/googlefulltext directory. The full path
### to the required files are programatically configured and the output files permissions are
### set for all user to have access.

### Command structure: sh slurm_nplsbatch.sh


### set the inputs directory as a variable
directory=$(eval echo $NPL_BASE/nplmatch/inputs)

### extracts intext from pwd
directory1=$(pwd)
frontorintext=${directory1:54}

### set the full paths to the windows- files for intext citations
fullpath="$directory/$frontorintext/googlefulltext"


TEMPFILE=./slurmfile.slurm
NWIN=$(ls $fullpath/windows-* | wc -l)
FILT_ID=10001

echo ""
echo "The number of windows- files to process is $NWIN"

for i in $fullpath/windows-*
do
 s=$(eval echo ${i:62:20} | sed -e "s/\///")
 echo "doing $s"
 echo "#!/bin/bash" > $TEMPFILE
 echo "#SBATCH -p xlarge" >> $TEMPFILE
 echo "#SBATCH -J fil$FILT_ID" >> $TEMPFILE
 echo "#SBATCH -t 12:00:00" >> $TEMPFILE
 echo "#SBATCH --wckey=marxnfs1" >> $TEMPFILE
 echo "module load perl5-libs" >> $TEMPFILE
# echo "perl $directory/patentscripts/$frontorintext/frankenfilter.pl $fullpath/windows-$FILT_ID > $fullpath/filtered-$FILT_ID 2> $fullpath/skipped-$FILT_ID" >> $TEMPFILE
 echo "perl $directory/patentscripts/$frontorintext/frankenfilter.pl $fullpath/windows-$FILT_ID > $fullpath/filtered-$FILT_ID 2> $fullpath/skipped-$FILT_ID" >> $TEMPFILE
 echo "chmod 777 $fullpath/filtered-$FILT_ID" >> $TEMPFILE
 echo "chmod 777 $fullpath/skipped-$FILT_ID" >> $TEMPFILE
 ((FILT_ID++))
 sbatch $TEMPFILE
 sleep 0.1
done
