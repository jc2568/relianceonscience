import os,shutil
import sys
import string

"""
Author: Joshua Chu
Date: January 27. 2023

This Python script checks to see if the any subdirectories in the splitpagevol_patent/body
directory is empty. The script indentifies the empty directories and prints them for inspection.

Command structure: python3 checkspvforempty [year] [frontorintext]
"""

# input parameters from user
year = sys.argv[1]
frontorintext = sys.argv[2]

pwd=os.getcwd()

fullpath=os.path.join(pwd,frontorintext,year)

alpha=[0,1,2,3,4,5,6,7,8,9]

for i in sorted(os.listdir(fullpath)):

    dir=os.listdir(os.path.join(fullpath,i))

    if len(dir) == 0:
        print("The",os.path.join(year,i),"Directory is Empty")

    else:
       pass
