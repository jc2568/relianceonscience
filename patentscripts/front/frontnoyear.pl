#!/local/bin/perl

require "$ENV{'NPL_BASE'}/nplmatch/config.pl";

$CURRENTYR="$CURRENTYR";

while (<>) {
 $hasyear = 0;
 for ($year=1800; $year <= $CURRENTYR; $year++) {
  $hasyear = 1 if /\D$year\D/;
 }
 print if $hasyear==0;
}
