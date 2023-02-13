#!/bin/bash

### Author: Joshua Chu
### Date: February 6, 2023

### command structure: sh extractgrobidwindowpiecewise.sh


### input year from config file
#year=$(perl $NPL_BASE/nplmatch/config.pl)
year=2015

### crate the full path to the directory containing the files to be processed and directory for the
### processed files to be saved
grobidpath="$NPL_BASE/nplmatch/grobid/window"

echo "Are you doing an annual update or batch?"

read varname

if [[ $varname != "annual" ]] && [[ $varname != "batch" ]]
then
 echo "Please enter a valid option: <annual or batch>"

fi

if [[ $varname == "annual" ]]
then

 input=$(eval echo $grobidpath/$year/directory_grobid)
 output=$(eval echo $grobidpath/$year/directory_grobid/directory_grobid_out)
 numfiles=$(ls $input/windowscombined-* | wc -l)
 PARAS_ID=10001

 for i in $input/windowscombined-*
 do

  if [ -s $output/grobidwindowoutput-$PARAS_ID ] && [ -f $output/grobidwindowoutput-$PARAS_ID ]
  then
   ((PARAS_ID++))
   continue

  elif [ -s $output/grobidwindowoutput-$PARAS_ID ] || [ -f $output/grobidwindowoutput-$PARAS_ID ]
  then
   echo "doing windowscombined-$PARAS_ID"
   python3 $patentscripts/intext/multi_proc_prog.py $input/windowscombined-$PARAS_ID $output/grobidwindowoutput-$PARAS_ID

  else
   echo "doing windowscombined-$PARAS_ID"
   python3 $patentscripts/intext/multi_proc_prog.py $input/windowscombined-$PARAS_ID $output/grobidwindowoutput-$PARAS_ID

  fi

  ((PARAS_ID++))

 done

elif [[ $varname == "batch" ]]
then

 input=$(eval echo $grobidpath/grobidbatch/directory_grobid)
 output=$(eval echo $grobidpath/grobidbatch/directory_grobid/directory_grobid_out)
 numfiles=$(ls $input/windowscombined-* | wc -l)
 PARAS_ID=10001

 for i in $input/windowscombined-*
 do

  if [ -s $output/grobidwindowoutput-$PARAS_ID ] && [ -f $output/grobidwindowoutput-$PARAS_ID ]
  then
   ((PARAS_ID++))
   continue

  elif [ -s $output/grobidwindowoutput-$PARAS_ID ] || [ -f $output/grobidwindowoutput-$PARAS_ID ]
  then
   echo "doing windowscombined-$PARAS_ID"
   python3 $patentscripts/intext/multi_proc_prog.py $input/windowscombined-$PARAS_ID $output/grobidwindowoutput-$PARAS_ID

  else
   echo "doing windowscombined-$PARAS_ID"
   python3 $patentscripts/intext/multi_proc_prog.py $input/windowscombined-$PARAS_ID $output/grobidwindowoutput-$PARAS_ID

  fi

  ((PARAS_ID++))

 done

fi
