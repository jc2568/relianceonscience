#!/bin/bash

### This script generates a set of Perl scripts to peform loose matches. The output
### files are saved in the year_regex_scripts_body_dBase directory. An old version of
### this script that used mag files can be found in the doNotDelete directory

### Script usage: sh slurm_buildjournalregex_byyear_body.sh. In order to use different
### databases, make sure to change the dBase variable below. The $year variable is obtained
### from the config.pl script that you should have already modified to the current year.
### If you have not done this already, please navigate to $NPL_BASE/nplmatch/config.pl
### and change the year variable to the current year. Not performing this step will
### result in no matches for the current year.

dBase=oa # mag or wos or oa

year=$(perl /home/fs01/nplmatchroot/nplmatch/config.pl)

for ((i=1800; i<=$year; i++))
do
 TEMPFILE=./slurmfile.slurm
 echo "buildtitleregex_byyear_body $i"
 echo "#!/bin/bash" > $TEMPFILE
 echo "#SBATCH -p small,large" >> $TEMPFILE
 echo "#SBATCH -J bjyb${i}" >> $TEMPFILE
 echo "#SBATCH -t 14-00:00" >> $TEMPFILE
 echo "#SBATCH --wckey=marxnfs1" >> $TEMPFILE
 echo "" >> $TEMPFILE
 echo "perl buildjournalregex_byyear_body.pl $dBase $i" >> $TEMPFILE
sbatch $TEMPFILE
sleep 0.1
done
