import os

file1 = os.listdir("./year_regex_scripts_front_oa")
file1_list=[]
for x in file1:
   short_txt = x[:13]
   file1_list.append(short_txt)

file2 = os.listdir("./year_regex_output_front_oa")
file2_list=[]
for x in file2:
    short_txt2 = x[:13]
    file2_list.append(short_txt2)
for i in file1_list:
    if i in file2_list:
        pass
    else:
        print(i + " is not in year_regex_output_front_oa")


file3 = os.listdir("./year_regex_scored_front_oa")
file3_list = []
for x in file3:
    short_txt3 = x[:13]
    file3_list.append(short_txt3)
for i in file1_list:
    if i in file3_list:
       pass
    else:
        print(i + " is not in year_regex_scored_front_oa")
