#!/usr/local/bin/perl
$YEAR = $ARGV[0];
#print "$YEAR\n";
while (<STDIN>) {
#chomp;
 # year in the middle of something else
# print if /[\[\] ,;:_\.\(\)\{\}\n\"\'\<\>\?\@\#\~]$SGE_TASK_ID[\[\] ,;:_\.\(\)\{\}\n\"\'\<\>\?\@\#\~]/;
 print if /[\[\] ,;:_\.\(\)\{\}\n\"\'\<\>\?\@\\~]$YEAR[\[\] ,;:_\.\(\)\{\}\n\"\'\<\>\?\@\#\~]/;
 # year at the start of the line
 print if /^$YEAR[\[\] ,;:_\.\(\)\{\}\n\"\'\<\>\?\@\#\~]/;
 ## year at the end of the line
# print if /[\[\] ,;:_\.\(\)\{\}\n\"\'\<\>\?\@\#\~]$SGE_TASK_ID$/;
 print if /[\[\] ,;:_\.\(\)\{\}\n\"\'\<\>\?\@\\~]$YEAR$/;
}
