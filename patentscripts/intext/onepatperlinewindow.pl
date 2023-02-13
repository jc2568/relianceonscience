
#!/usr/local/bin/perl

$lastpat = "";
$fencepost = 1;


while (<>) {
  if (/(.*)\t(\d\d\d\d)(.*)\t(.*)/) {
  $patent = $1;
  $line = $4;
 # print "\n\nPAT:$patent\tLINE:$line\n
 # print "PAT:$patent\tLINES:$lines\n";
 #starting condition
 if($fencepost==1){
   $lines = $line;
   $lastpat = $patent; 
   $fencepost=0;
 } else {
   if (($patent eq $lastpat)) {
        $lines = $lines." ".$line;
	       } else {   
           print "$lastpat\t$lines\n";
           $lines = $line; 
           $lastpat = $patent;     
      } 
    }
  }
}
