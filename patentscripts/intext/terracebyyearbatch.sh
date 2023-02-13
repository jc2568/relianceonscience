#!/bin/bash


### Author: Joshua Chu
### Date: January 12, 2023

### this script is a modification of a script copied from the /nplmatch/inputs/body/fulltext_2021j/
### directory and processes the files downloaded from Google for the annual update

### Command structure: sh terracebyyearbatch.sh


### input year from config file
year=$(perl $NPL_BASE/nplmatch/config.pl)

### set the inputs directory as a variable
directory=$(eval echo $NPL_BASE/nplmatch/inputs/intext/googlefulltext)

### construct the necessary paths for processing
fullpath="$directory/fulltext"
grobid="$NPL_BASE/nplmatch/grobid/window/grobidbatch/directory_grobid/directory_grobid_out"
savepath="$directory/fulltext/bodybyrefyear"

### when creating this script, slurm was tied up and the server had to be used to run the script. If
### you want to use slurm uncomment the sections below and then comment out the first cat command
TEMPFILE=./slurmFile.slurm

for ((i=1800; i<=$year; i++))
 do
 echo "doing $i"
 echo "#!/bin/bash" > $TEMPFILE
 echo "#SBATCH -p xlarge" >> $TEMPFILE
 echo "#SBATCH -J tbyb${i}" >> $TEMPFILE
 echo "#SBATCH -t 12:00:00" >> $TEMPFILE
 echo "#SBATCH --wckey=marxnfs1" >> $TEMPFILE
 echo "" >> $TEMPFILE
 echo "module load perl5-libs" >>$TEMPFILE
 echo "cat $fullpath/bodynpl_digitized_lc.tsv  $grobid/parsegrobidwindowoutput_lc.txt | perl ./terracenpl.pl $i > $savepath/body_$i.tsv" >> $TEMPFILE
 echo "chmod 777 $savepath/body_$i.tsv" >> $TEMPFILE
 sbatch $TEMPFILE

done
