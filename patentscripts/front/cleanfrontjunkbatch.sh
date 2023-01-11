#!/bin/bash

year=$(perl /home/fs01/nplmatchroot/nplmatch/config.pl)
directory=$(eval echo $NPL_BASE/nplmatch/inputs/front/googlebatchdownload)

grep "[a-zA-Z]" $directory/cleanparas-100* | sort -u | tr [:upper:] [:lower:] | \
      perl $NPL_BASE/nplmatch/inputs/patentscripts/front/screenfrontjunk.pl > $directory/front$year\_clean.tsv

chmod 777 $directory/front$year\_clean.tsv
