#!/bin/bash -l

#$ -t 1900-1979
#$ -j y
#$ -N bc_ws_ft
#$ -P marxnsf1
#$ -V

chmod 664 $SGE_STDOUT_PATH
chmod 664 $SGE_STDERR_PATH

$NPL_BASE/nplmatch/splitpagevol_articles/buildsplitregex_byyear_front_lev.pl wos $SGE_TASK_ID


