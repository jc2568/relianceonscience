#!/bin/bash

### Author: Joshua Chu
### Date: December 15, 2022

### This script creates a soft-link to files in the raw subdirectory for the current year. The config.pl
### file is not utilized to obtain the current year because the script extracts the year using the
### present working directory unix command. By doing this, the subsequent files are programatically
### created to symbolically link to the raw files. Permissions are changed to 777.

### Author: Joshua Chu
### Edited: January 4, 2023

### The script was edited to work from the /nplmatch/inputs/patentscripts/{front or intext} directory and
### utilizes the year obtained from the config.pl script. This removes the requirement to copy scripts
### to newly created directories.

### Command structure: sh createparaslink.sh


### input year from config file
year=$(perl $NPL_BASE/nplmatch/config.pl)

### set the inputs directory as a variable
directory=$(eval echo $NPL_BASE/nplmatch/inputs/)

### extract front or intext from the pwd; this will be utilized to construct the full directory paths
### in the below steps
directory1=$(pwd)
frontorintext=${directory1:54}

### determine how many sub-directories are present in the year directory
numdir=$(find $directory$frontorintext/$year -mindepth 1 -maxdepth 1 -type d | wc -l)
subdir=$(printf "%03d\n" $numdir)

### set the full paths to the raw files for front and intext (uspto and epo)
fullfrontpathraw="$directory$frontorintext/$year/$subdir/world_data/raw"
fullintextpathraw="$directory$frontorintext/$year/$subdir/uspto_data/raw"
epopathraw="$directory$frontorintext/$year/$subdir/epo_data/raw"

t=10001

### this section is for front citations only
if [ $frontorintext == "front" ]
then
 fullfrontpathpro="$directory$frontorintext/$year/$subdir/processed"

 for i in $fullfrontpathraw/*99.txt
 do
  ln -s $i $fullfrontpathpro/paras-$t;
  chmod 777 $fullfrontpathpro/paras-$t
  echo "Symbolic link was created for file paras-$t"
  ((t+=1));
 done

### this section is for intext citations only
elif [ $frontorintext == "intext" ]
then
 fullintextpathpro="$directory$frontorintext/$year/$subdir/processed"

 for i in $fullintextpathraw/*99.txt
 do
  ln -s $i $fullintextpathpro/paras-$t;
  chmod 777 $fullintextpathpro/paras-$t
  echo "Symbolic link was created for file paras-$t"
  ((t+=1));
 done

 if [ -d $epopathraw ]
 then
  for i in $epopathraw/*mod.txt
  do
   ln -s $i $fullintextpathpro/paras-$t;
   chmod 777 $fullintextpathpro/paras-$t
   echo "Symbolic link was created for file paras-$t"
   ((t+=1));
  done
 else
  echo "There are no EPO patents to process"
 fi

fi
