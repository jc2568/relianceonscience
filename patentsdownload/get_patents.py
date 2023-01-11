import os,shutil
import sys
from google.cloud import bigquery
from google.oauth2 import service_account

"""
Author: Murt Bahr 20200723
This Python script is used through the command line to retrieve the patents data, both body and front,
without the need to hard-code anything. Just follow the instruction the technical documentation.
Any successful retrieval will be logged into the data_tracker.txt. And will be used later to raise
an error if the range has been already downloaded.
Command structure: python get_patents_dev.py [cred] [front,body] [a] [b]

Editor: Joshua Chu 04/06/2022
In the previous version, the user was required to create a directory structure to download the data
from Google. This script was modified to programatically faciliate a directory structure and the
user may utilize to prevent the user from accidentally introducing errors into the pipeline. Using
the command structure above, subdirectories are automatically created under the front and/or body
directories, which was not done in the previous version. Each annual update is saved in individual
folders and with the top-level directory indicating the year.

Editor: Joshua Chu 01/04/2023
This version contains substantial changes to the script compared to the two previous versions. First,
the script can now perform quarterly or monthly updates if the user chooses to perform more than the
annual update. In order to concisely manage the data structure, each update is saved in a new sub-
directory under the current year directory. In other words, quarterly updates for the year 2000 will
contain sub-directories called 001, 002, 003, and 004. Each sub-directory is programmatically added to
the top-level directory rather than having the user create the directory and possible introduce errors.

Next, rather than downloading the annual front and body citations, the script has the functionality of
downloading front citations across date ranges. While this technically could be performed in previous
versions of this script, the software did not programmatically separate the bulk download file from the
annual updates, which caused confusion when trying to identify the files that must be processed when
these files were in the same directory. Additionally, there is an error message included in the script
if a user attempts to overwrite an existing file in the /nplmatch/inputs/front/googlebatchdownload/raw
directory. An intentional removal of the /raw directory must be performed before a new batch of citations
can be downloaded. BE SURE YOU WANT TO DO THIS.

Lastly, except for the raw citation files downloaded from Google, the directory structure under each
year in the /nplmatch/inputs/front/ or /nplmatch/inputs/intext/ directories will not contain any files
or scripts to process the raw data. The new directory structure was designed to use the scripts found
in the /nplmatch/inputs/patentscripts/front or /nplmatch/inputs/patentscripts/intext directories. This
resolves any issues with multiple script versions and any confusion in which script to execute. Details
on the execution and command structure for the individual scripts are written within each file.

Command structure: python3 get_patents.py [.json] [front,body] [a] [b]
"""

# input parameters from user
cred = sys.argv[1]
pos = sys.argv[2]  # [front,body]
a = sys.argv[3]  # included
b = sys.argv[4]  # excluded

# set directories for front and body locations and necessary scripts to copy into processed directory
inFt="/home/fs01/nplmatchroot/nplmatch/inputs/front"
inBd="/home/fs01/nplmatchroot/nplmatch/inputs/intext"
googleBatchRaw="/home/fs01/nplmatchroot/nplmatch/inputs/front/googlebatchdownload/raw"

# use date argv to subset the year
yr = a[0:4:1]
yrb = b[0:4:1]

# check to see if the year in input parameters a and b are the same to enter the googlebatch download
# section of the script
if yr != yrb:
    if os.path.exists(googleBatchRaw):
        g="""You are attempting to download front citations across a range of years. This has been previously
for the years 1800 through 2022 and can be found in the /inputs/front/googlebatchdownload/raw subdirectory. If you
intend to replace this file, you must remove the /raw subdirectory and delete the data_tracker.txt file prior
to downloading a new set of front citations. Removing the raw subdirectory will allow this program to save the
new set of data in a newly created raw subdirectory. Please be sure this is what you want to do."""
        print(g,"\n")
        sys.exit()
    else:
        if pos == 'front':
            dPath = "/home/fs01/nplmatchroot/nplmatch/inputs/front/googlebatchdownload"

            os.umask(0)
            os.makedirs(googleBatchRaw)
            h="""The raw subdirectory for the googlebatchdownload directory does not exist and was created
to download the new front citation data."""
            print(h)

# if not doing a googlebatch download, enter the section to download front or intext raw data and construct
# the necessary directory structure to save the raw and processed files
elif pos == 'front':
    if not os.path.exists(os.path.join(os.environ['NPL_BASE'],"nplmatch/inputs",pos,yr)):
        os.umask(0)
        os.makedirs(os.path.join(os.environ["NPL_BASE"],"nplmatch/inputs",pos,yr,"001","world_data","raw"))
        os.makedirs(os.path.join(os.environ["NPL_BASE"],"nplmatch/inputs",pos,yr,"001","processed","frontbyrefyear"))
        os.makedirs(os.path.join(os.environ["NPL_BASE"],"nplmatch/inputs",pos,yr,"001","processed","BatchOutput"))
        os.makedirs(os.path.join(os.environ["NPL_BASE"],"nplmatch/inputs",pos,yr,"001","processed","checkeveryjournal","journalbyrefyear"))

        dPath = os.path.join(os.environ["NPL_BASE"],"nplmatch/inputs",pos,yr,"001")
        dPath1 = os.path.join(os.environ["NPL_BASE"],"nplmatch/inputs",pos,yr,"001")

    elif os.path.exists(os.path.join(os.environ['NPL_BASE'],"nplmatch/inputs",pos,yr)):
        t=len(os.listdir(os.path.join(os.environ['NPL_BASE'],"nplmatch/inputs",pos,yr)))
        s=(os.listdir(os.path.join(os.environ['NPL_BASE'],"nplmatch/inputs",pos,yr))[t-1])

        dPath = os.path.join(os.environ["NPL_BASE"],"nplmatch/inputs",pos,yr,s)
        s=str(int(s) + 1).zfill(3)

        os.umask(0)
        os.makedirs(os.path.join(os.environ["NPL_BASE"],"nplmatch/inputs",pos,yr,s,"world_data","raw"))
        os.makedirs(os.path.join(os.environ["NPL_BASE"],"nplmatch/inputs",pos,yr,s,"processed","frontbyrefyear"))
        os.makedirs(os.path.join(os.environ["NPL_BASE"],"nplmatch/inputs",pos,yr,s,"processed","BatchOutput"))
        os.makedirs(os.path.join(os.environ["NPL_BASE"],"nplmatch/inputs",pos,yr,s,"processed","checkeveryjournal","journalbyrefyear"))

        dPath1 = os.path.join(os.environ["NPL_BASE"],"nplmatch/inputs",pos,yr,s)

elif pos == 'body':
    if not os.path.exists(os.path.join(os.environ['NPL_BASE'],"nplmatch/inputs","intext",yr)):
        os.umask(0)
        os.makedirs(os.path.join(os.environ["NPL_BASE"],"nplmatch/inputs","intext",yr,"001","uspto_data","raw"))
        os.makedirs(os.path.join(os.environ["NPL_BASE"],"nplmatch/inputs","intext",yr,"001","epo_data","raw"))
        os.makedirs(os.path.join(os.environ["NPL_BASE"],"nplmatch/inputs","intext",yr,"001","processed","BatchOutput"))
        os.makedirs(os.path.join(os.environ["NPL_BASE"],"nplmatch/inputs","intext",yr,"001","processed","checkeveryjournal","journalbodybyrefyear"))
        os.makedirs(os.path.join(os.environ["NPL_BASE"],"nplmatch/inputs","intext",yr,"001","processed","fulltext","bodybyrefyear"))

        dPath = os.path.join(os.environ["NPL_BASE"],"nplmatch/inputs","intext",yr,"001")
        dPath1 = os.path.join(os.environ["NPL_BASE"],"nplmatch/inputs","intext",yr,"001")

    elif os.path.exists(os.path.join(os.environ['NPL_BASE'],"nplmatch/inputs","intext",yr)):
        t=len(os.listdir(os.path.join(os.environ['NPL_BASE'],"nplmatch/inputs","intext",yr)))
        s=(os.listdir(os.path.join(os.environ['NPL_BASE'],"nplmatch/inputs","intext",yr))[t-1])

        dPath = os.path.join(os.environ["NPL_BASE"],"nplmatch/inputs","intext",yr,s)
        s=str(int(s) + 1).zfill(3)

        os.umask(0)
        os.makedirs(os.path.join(os.environ["NPL_BASE"],"nplmatch/inputs","intext",yr,s,"uspto_data","raw"))
        os.makedirs(os.path.join(os.environ["NPL_BASE"],"nplmatch/inputs","intext",yr,s,"epo_data","raw"))
        os.makedirs(os.path.join(os.environ["NPL_BASE"],"nplmatch/inputs","intext",yr,s,"processed","BatchOutput"))
        os.makedirs(os.path.join(os.environ["NPL_BASE"],"nplmatch/inputs","intext",yr,s,"processed","checkeveryjournal","journalbodybyrefyear"))
        os.makedirs(os.path.join(os.environ["NPL_BASE"],"nplmatch/inputs","intext",yr,s,"processed","fulltext","bodybyrefyear"))

        dPath1 = os.path.join(os.environ["NPL_BASE"],"nplmatch/inputs","intext",yr,s)

if pos in ['front', 'body'] and int(a) in range(10000000, 99999999) and int(b) in range(10000000, 99999999):
    pass
else:
    print("Error: one of the entered parameters is not valid.")
    sys.exit()

minmonth = a[4:6:1]
maxmonth = b[4:6:1]

# if the years to do not match for a and b, it is assumed the user is trying to download data
# ranging multiple years. The first section of this script tests for this case, and the second
# section focuses on the annual updates for the front and intext citations. In the first case,
# only batch downloads will be retrieved
if yr != yrb:
    print("not equal")
    #Get Google Cloud credentials. [documentation: https://cloud.google.com/bigquery/docs/reference/libraries#client-libraries-usage-python]
    path = './' + cred
    credentials = service_account.Credentials.from_service_account_file(
        path,
        scopes=["https://www.googleapis.com/auth/cloud-platform"],
    )

    # Construct a BigQuery client object.
    client = bigquery.Client(
        credentials=credentials,
        project=credentials.project_id,)

    if pos == 'front':
        query = """
            SELECT pub.publication_number, citations.npl_text
            FROM `patents-public-data.patents.publications` as pub
            CROSS JOIN UNNEST(citation) as citations
            WHERE citations.npl_text <> ""
            AND grant_date >= {} AND grant_date < {}
        """.format(a, b)
    #create empty string
    results = ""
    #Try: send query, populate string, write to file, and update the tracker.
    try:
        # querying
        print("Sending query to Google Cloud..")
        query_job = client.query(query)  # Make an API request.
        i = 0

        for row in query_job:
            # Row values can be accessed by field name or index.
            # Sometimes a row is empty having no data, so use TRY to catch that. This is an error due to GoogleQuery
            try:
                # for first column, that's the ID, type double underscores before and after
                new_line = "__" + row[0] + "__" + "\t" + row[1] + '\n'
            except IndexError:
                new_line = ""
            results += new_line
            i += 1

        # Open a new text file to store the queried years, name the file as a range #####################
        if (pos == 'front') and (yr != yrb):
            output_file_name = googleBatchRaw + "/" + a + "-" + b + ".txt"
            output_file = open(output_file_name, "w")
            output_file.write(results)

            os.chmod(output_file_name,0o777)
            output_file.close()

            # If no error, then update the data_tracker file with the queried years range
            file = 'data_tracker.txt'
            data_tracker_file = open(os.path.join(dPath, file), "a")
            data_tracker_file.write(pos + ',' + a + ',' + b + ',' + str(i) + '\n')

            os.chmod(os.path.join(dPath, file),0o777)
            data_tracker_file.close()

        print("Done! {} rows were downloaded to {}.".format(i, output_file_name))
    #If this TRY is interrupter, then print ERROR
    except Exception as e:
        # print error message
        print("ERROR! ", e)

else:
    for j in range(int(minmonth), int(maxmonth)+1):
        g=str(yr)+str(int(j)).zfill(2)+str(00).zfill(2)
        h=str(yr)+str(int(j)).zfill(2)+str(99)
        print(g,h)

        #Get Google Cloud credentials. [documentation: https://cloud.google.com/bigquery/docs/reference/libraries#client-libraries-usage-python]
        path = './' + cred
        credentials = service_account.Credentials.from_service_account_file(
            path,
            scopes=["https://www.googleapis.com/auth/cloud-platform"],
        )

        # Construct a BigQuery client object.
        client = bigquery.Client(
            credentials=credentials,
            project=credentials.project_id,)

        if pos == 'front':
            query = """
                SELECT pub.publication_number, citations.npl_text
                FROM `patents-public-data.patents.publications` as pub
                CROSS JOIN UNNEST(citation) as citations
                WHERE citations.npl_text <> ""
                AND grant_date >= {} AND grant_date < {}
            """.format(g, h)
        elif pos == 'body':
            query = """
                SELECT pub.publication_number, description.text
                FROM `patents-public-data.patents.publications` as pub
                CROSS JOIN UNNEST(description_localized) as description
                WHERE description.text <> ""
                AND grant_date >= {} AND grant_date < {}
            """.format(g, h)
        #create empty string
        results = ""
        #Try: send query, populate string, write to file, and update the tracker.
        try:
            # querying
            print("Sending query to Google Cloud..")
            query_job = client.query(query)  # Make an API request.
            i = 0

            for row in query_job:
                # Row values can be accessed by field name or index.
                # Sometimes a row is empty having no data, so use TRY to catch that. This is an error due to GoogleQuery
                try:
                    # for first column, that's the ID, type double underscores before and after
                    new_line = "__" + row[0] + "__" + "\t" + row[1] + '\n'
                except IndexError:
                    new_line = ""
                results += new_line
                i += 1

            # Open a new text file to store the queried years, name the file as a range #####################
            if (pos == 'front') and (yr != yrb):
                output_file_name = googleBatchRaw + "/" + g + "-" + h + ".txt"
                output_file = open(output_file_name, "w")
                output_file.write(results)

                os.chmod(output_file_name,0o777)
                output_file.close()

                # If no error, then update the data_tracker file with the queried years range
                file = 'data_tracker.txt'
                data_tracker_file = open(os.path.join(dPath, file), "a")
                data_tracker_file.write(pos + ',' + a + ',' + b + ',' + str(i) + '\n')

                os.chmod(os.path.join(dPath, file),0o777)
                data_tracker_file.close()

            elif (pos == 'front') and (yr == yrb):
                output_file_name = dPath1 + "/" + "world_data" + "/" + "raw" + "/" + g + "-" + h + ".txt"
                output_file = open(output_file_name, "w")
                output_file.write(results)

                os.chmod(output_file_name,0o777)
                output_file.close()

                # If no error, then update the data_tracker file with the queried years range
                file = 'data_tracker.txt'
                data_tracker_file = open(os.path.join(dPath1, "world_data", "raw", file), "a")
                data_tracker_file.write(pos + ',' + g + ',' + h + ',' + str(i) + '\n')

                os.chmod(os.path.join(dPath1, "world_data", "raw", file),0o777)
                data_tracker_file.close()

            elif pos == 'body':
                output_file_name = dPath1 + "/" + "uspto_data" + "/" + "raw" + "/" + g + "-" + h + ".txt"
                output_file = open(output_file_name, "w")
                output_file.write(results)

                os.chmod(output_file_name,0o777)
                output_file.close()

                # If no error, then update the data_tracker file with the queried years range
                file = 'data_tracker.txt'
                data_tracker_file = open(os.path.join(dPath1, "uspto_data", "raw", file), "a")
                data_tracker_file.write(pos + ',' + g + ',' + h + ',' + str(i) + '\n')

                os.chmod(os.path.join(dPath1, "uspto_data", "raw", file),0o777)
                data_tracker_file.close()

            print("Done! {} rows were downloaded to {}.".format(i, output_file_name))
        #If this TRY is interrupter, then print ERROR
        except Exception as e:
            # print error message
            print("ERROR! ", e)
