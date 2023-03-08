#!/bin/bash

### This script generates a set of Perl scripts to peform loose matches. The output
### files are saved in the year_regex_scripts_front_dBase directory. An old version of
### this script that used mag files can be found in the doNotDelete directory

### Script usage: sh slurm_buildtitleregex_1799_front.sh. In order to use different databases, make sure
### to change the ARTICLEDB variable below.

dBase=oa # mag or oa or wos

TEMPFILE=./slurmfile.slurm
echo "buildtitleregex_1799_front"
echo "#!/bin/bash" > $TEMPFILE
echo "#SBATCH -p xlarge" >> $TEMPFILE
echo "#SBATCH -J stfo1799" >> $TEMPFILE
echo "#SBATCH -t 14-00:00" >> $TEMPFILE
echo "#SBATCH --wckey=marxnfs1" >> $TEMPFILE
echo "" >> $TEMPFILE
echo "perl $NPL_BASE/nplmatch/splittitle_articles/buildtitleregex_1799_front.pl $dBase" >> $TEMPFILE
sbatch $TEMPFILE
sleep 0.1
