import os,shutil
import sys
import string

"""
Author: Joshua Chu
Date: January 27. 2023

This Python script checks to see if the any subdirectories in the split{title,journal}_patent/body
directory is empty. The script indentifies the empty directories and prints them for inspection.

Command structure: python3 checkjtforempty [year] [frontorintext]
"""

# input parameters from user
year = sys.argv[1]
frontorintext = sys.argv[2]

pwd=os.getcwd()

fullpath=os.path.join(pwd,frontorintext,year)

alpha=list(string.ascii_lowercase)

for i in sorted(os.listdir(fullpath)):

    for j in alpha:
        dir=os.listdir(os.path.join(fullpath,i,j))

        if len(dir) == 0:
            print("The",os.path.join(year,i,j),"Directory is Empty")

        else:
           pass
