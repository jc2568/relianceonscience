#!/bin/bash


### Author: Joshua Chu
### Date: February 6, 2023


### Command structure: sh setupgrobidbatch.sh


### input year from config file
#year=$(perl $NPL_BASE/nplmatch/config.pl)
year=2015

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
 if [ -d "$grobidpath/window/$year" ]
 then
  echo "Directory $grobidpath/window/$year exists"

 else
  echo "Error: Directory $grobidpath/window/$year does not exist"
  echo "The directory $grobidpath/window/$year was created"
  mkdir -p $grobidpath/window/$year/directory_grobid/directory_grobid_out
  chmod -R 777 $grobidpath/window/$year

 fi

elif [[ $varname == "batch" ]]
then
 if [ -d "$grobidpath/window/grobidbatch" ]
 then
  echo "Directory $grobidpath/window/grobidbatch exists"

 else
  echo "Error: Directory $grobidpath/window/grobidbatch does not exist"
  echo "The directory $grobidpath/window/grobidbatch was created"
  mkdir -p $grobidpath/window/grobidbatch/directory_grobid//directory_grobid_out
  chmod -R 777 $grobidpath/window/grobidbatch

 fi

fi
