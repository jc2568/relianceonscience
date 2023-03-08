#!/bin/bash

### this slurm script scores the output that was created and saved in the year_regex_output_body_ARTICLEDB
### directory. The resulting files will be saved in year_regex_scored_body_ARTICLEDB directory

### Script usage: sh slurm_scoring_body.sh. In order to use different databases, make sure
### to change the ARTICLEDB variable below. The $year variable is obtained from the config.pl
### script that you should have already modified to the current year. If you have not done
### this already, please navigate to $NPL_BASE/nplmatch/config.pl and change the year variable
### to the current year. Not performing this step will result in no matches for the current year.


SPLITTYPE=title
JOBTYPE=stbo # stbm or stbo
FRONTORBODY=body
ARTICLEDB=oa # mag or oa or wos

year=$(perl /home/fs01/nplmatchroot/nplmatch/config.pl)

for ((i=1800; i<=$year; i++))
do
 TEMPSLURMFILE=./tempslurm/${JOBTYPE}${i}.slurm
 echo
 echo "doing $i"
 FILESFORYEAR=$(ls -l year_regex_output_${FRONTORBODY}_${ARTICLEDB}/year${i}-* | wc -l)
 echo "found $FILESFORYEAR files for $i"
 echo "writing $TEMPSLURMFILE"
 echo "#!/bin/bash -l" > $TEMPSLURMFILE
 echo "" >>$TEMPSLURMFILE
 echo "#SBATCH -p small,large,xlarge" >> $TEMPSLURMFILE
 echo "#SBATCH -t 96:00:00" >> $TEMPSLURMFILE
 echo "#SBATCH -J ${JOBTYPE}${i}" >> $TEMPSLURMFILE
 echo "#SBATCH --array=1-${FILESFORYEAR}" >>$TEMPSLURMFILE
 echo "" >> $TEMPSLURMFILE
 echo "FILE_ID=\$(( (\$SLURM_ARRAY_TASK_ID + 999) ))" >>$TEMPSLURMFILE
 echo "" >> $TEMPSLURMFILE
 echo "module load perl5-libs" >> $TEMPSLURMFILE ###Josh added because this script would not run properly
 echo "perl $NPL_BASE/nplmatch/process_matches/score_matches.pl $NPL_BASE/nplmatch/split${SPLITTYPE}_articles/year_regex_output_${FRONTORBODY}_${ARTICLEDB}/year${i}-\$FILE_ID.txt -body > $NPL_BASE/nplmatch/split${SPLITTYPE}_articles/year_regex_scored_${FRONTORBODY}_${ARTICLEDB}/year${i}-\$FILE_ID.txt" >>$TEMPSLURMFILE
 echo "chmod 777 $NPL_BASE/nplmatch/split${SPLITTYPE}_articles/year_regex_scored_${FRONTORBODY}_${ARTICLEDB}/year${i}-\$FILE_ID.txt" >> $TEMPSLURMFILE
 echo "sbatching $TEMPSLURMFILE"
 sbatch $TEMPSLURMFILE
done

