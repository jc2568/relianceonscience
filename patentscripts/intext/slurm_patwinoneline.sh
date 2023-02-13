#!/bin/bash

### Author: Joshua Chu
### Date: February 6, 2023

### this script uses input files from the /input/intext directory. Depending on
### the user input, the program will process the annual update or batch process
### all years 1800-<the current year>. The current year is extracted from the
### config.pl file, so if you have not updated the file, the results obtained
### from the pipeline will not be the most up-to-date. The user is required
### to enter either "annual" or "batch", which indicates to the script the
### option it should select in the software below. Once "building" the
### necessary directories, the script than creates the slurm scripts to be
### executed by the workload manager. The output is saved in either a batch
### directory or an "annual" directory - this is the year extracted from the
### config.pl file.

### command structure: sh slurm_patwinoneline.sh


### input year from config file
year=$(perl $NPL_BASE/nplmatch/config.pl)

### crate the full path to the directory containing the files to be processed and directory for the
### processed files to be saved
grobidpath="$NPL_BASE/nplmatch/grobid"

echo "Are you doing an annual update or batch?"

read varname

if [[ $varname != "annual" ]] && [[ $varname != "batch" ]]
then
 echo "Please enter a valid option: <annual or batch>"

fi

if [[ $varname == "annual" ]]
then

 numdir=$(find $NPL_BASE/nplmatch/inputs/intext/$year -mindepth 1 -maxdepth 1 -type d | wc -l)
 subdir=$(printf "%03d\n" $numdir)

 input=$(eval echo $NPL_BASE/nplmatch/inputs/intext/$year/$subdir/processed)
 output=$(eval echo $grobidpath/window/$year/directory_grobid)

fi

if [[ $varname == "batch" ]]
then

 input=$(eval echo $NPL_BASE/nplmatch/inputs/intext/googlefulltext)
 output=$(eval echo $grobidpath/window/grobidbatch/directory_grobid)

fi

directory_grobid=$output
directory_input=$input

echo "The input directory is: $directory_input"
echo "The output directory is: $directory_grobid"

TEMPFILE=./slurmfile.slurm
NPARAS=$(ls  $directory_input/windows-* | wc -l)
echo $NPARAS
PARAS_ID=10001

for i in  $directory_input/windows-*
do
 echo "doing $windows-$PARAS_ID"
 echo "#!/bin/bash" > $TEMPFILE
 echo "#SBATCH -p large,xlarge" >> $TEMPFILE
 echo "#SBATCH -J $PARAS_ID" >> $TEMPFILE
 echo "#SBATCH -t 96:00:00" >> $TEMPFILE
 echo "#SBATCH --wckey=marxnfs1" >> $TEMPFILE
 echo "module load perl5-libs" >> $TEMPFILE
 echo "perl $patentscripts/intext/onepatperlinewindow.pl < $input/windows-$PARAS_ID > $output/windowscombined-$PARAS_ID" >> $TEMPFILE
 echo "chmod 777 $output/windowscombined-$PARAS_ID" >> $TEMPFILE
 ((PARAS_ID++))
 sbatch $TEMPFILE
 sleep 0.1

done
