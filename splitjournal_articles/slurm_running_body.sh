#!/bin/bash

### this slurm script executes the perl scripts that were created and saved in the
### year_regex_scripts_body_ARTICLEDB directory. The resulting .txt files will be
### saved in year_regex_output_body_ARTICLEDB directory

### Script usage: sh slurm_running_body.sh. In order to use different databases, make sure
### to change the ARTICLEDB variable below. The $CURRENTYR variable is obtained from the config.pl
### script that you should have already modified to the current year. If you have not done
### this already, please navigate to $NPL_BASE/nplmatch/config.pl and change the CURRENTYR variable
### to the current year. Not performing this step will result in no matches for the current year.


############ if something does not work, check that the $i variable is correctly set in the code below


SPLITTYPE=journal
JOBTYPE=xjba # xjbm or xjba
FRONTORBODY=body
ARTICLEDB=oa # mag or oa or wos

CURRENTYR=$(perl /home/fs01/nplmatchroot/nplmatch/config.pl)

for ((i=1800; i<=$CURRENTYR; i++))
do
 TEMPSLURMFILE=./tempslurm/${JOBTYPE}${i}.slurm
 rm -f $TEMPSLURMFILE
 echo
 echo "doing $i"
 FILESFORYEAR=$(ls -l year_regex_scripts_${FRONTORBODY}_${ARTICLEDB}/year${i}-* | wc -l)
 echo "found $FILESFORYEAR files for $i"
 echo "writing $TEMPSLURMFILE"
 echo "#!/bin/bash -l" > $TEMPSLURMFILE
 echo "" >>$TEMPSLURMFILE
 echo "#SBATCH -p xlarge,large,small" >> $TEMPSLURMFILE
 echo "#SBATCH -t 96:00:00" >> $TEMPSLURMFILE
 echo "#SBATCH -J ${JOBTYPE}${i}" >> $TEMPSLURMFILE
 echo "#SBATCH --array=1-${FILESFORYEAR}" >>$TEMPSLURMFILE
 echo "" >> $TEMPSLURMFILE
 echo "FILE_ID=\$(( (\$SLURM_ARRAY_TASK_ID + 999) ))" >>$TEMPSLURMFILE
 echo "" >> $TEMPSLURMFILE
 echo "module load perl5-libs" >> $TEMPSLURMFILE
 echo "perl $NPL_BASE/nplmatch/split${SPLITTYPE}_articles/year_regex_scripts_${FRONTORBODY}_${ARTICLEDB}/year${i}-\$FILE_ID.pl > $NPL_BASE/nplmatch/split${SPLITTYPE}_articles/year_regex_output_${FRONTORBODY}_${ARTICLEDB}/year${i}-\$FILE_ID.txt" >>$TEMPSLURMFILE
 echo "sbatching $TEMPSLURMFILE"
 chmod 777 $TEMPSLURMFILE
 sbatch $TEMPSLURMFILE
done

