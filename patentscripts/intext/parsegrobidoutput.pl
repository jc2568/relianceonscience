#!/usr/local/bin/perl
$debug = 0;
sub print_article {
  $npline = "";
  $npline.= $authors . " " if !($authors eq "");
  $npline.= " (" . $year . ") " if !($year eq "");
  $npline.= " \"" . $title . "\" " if !($title eq "");
  $npline.= " " . $journal . " " if !($journal eq "");
  $npline.= " Vol. " . $volume if !($volume eq "") && ($issue eq "");;
  $npline.= " Vol. " . $volume . "(" . $issue . ") " if !($volume eq "") && !($issue eq "");
  $npline.= " p. " . $firstpage . " " if !($firstpage eq "") && ($lastpage eq "");
  $npline.= " pp. " . $firstpage . "-" . $lastpage if !($firstpage eq "") && !($lastpage eq "");
  $npline.= " $note " if !($note eq "");
 # print only if there's an alpha after the patent # - not blank,n ot jus year
  if ($patent=~/^__US/) {
  }
  elsif ($patent=~/^__EP/) {
  }
  elsif ($patent=~/^US/) {
   $patent = "__" . $patent;
  }
  elsif ($patent=~/^_*U/) {
   $patent=~s/^_*U/__US/;
  }
  elsif ($patent=~/^U/) {
   $patent=~s/^U/__US/;
  }
  elsif ($patent=~/^_*S/) {
   $patent=~s/^_*S/__US/;
  }
  elsif ($patent=~/^S/) {
   $patent = "__U" . $patent;
  }
  elsif ($patent=~/^_*/) {
   $patent=~s/^_*/__US/;
  } 
  else {
   $patent = "__US" . $patent;
  }
  if (($patent=~m/\d/) && ($npline =~m/[a-zA-Z]/)) {
   print "\n\nyear>$year<\nvolume>$volume<\nissue>$issue<\npage1>$firstpage<\npagend>$lastpage<\nauthors>$authors<\njournal>$journal<\ntitle>$title<\neditor>$editor<\nnote>$note<\n" if ($debug==11);
   $legit = 1;
   # skip if all you have is year
   $legit = 0 if ($year ne "" && $authors eq "" && $title eq "" && $journal eq "" && $firstpage eq "");
   # skip if all you have is year and page
   $legit = 0 if ($year ne "" && $authors eq "" && $title eq "" && $journal eq "" && $firstpage ne "");
   # skip if all you have is journal
   $legit = 0 if ($year eq "" && $authors eq "" && $title eq "" && $journal ne "" && $firstpage eq "");
   # skip if all you have is journal and page
   $legit = 0 if ($year eq "" && $authors eq "" && $title eq "" && $journal ne "" && $firstpage ne "");
   # skip if all you have is author
   $legit = 0 if ($year eq "" && $authors ne "" && $title eq "" && $journal eq "" && $firstpage eq "");
   # skip if all you have is author and page but no year or volume or journal
   $legit = 0 if ($year eq "" && $authors ne "" && $title eq "" && $journal eq "" && $firstpage ne "" && $volume eq "");
   # skip if all you have is author and year, no volume/title/page 
   $legit = 0 if ($year ne "" && $authors ne "" && $title eq "" && $journal eq "" && $volume eq "" && $firstpage eq "");
   # skip if all you have is year and journal (no pages)
   $legit = 0 if ($year ne "" && $authors eq "" && $title eq "" && $journal ne "" && $firstpage eq "");
   # skip if all you have is page and journal (no year)
   $legit = 0 if ($year eq "" && $authors eq "" && $title eq "" && $journal eq "" && $firstpage ne "");
   # skip if all you have is author and journal
   $legit = 0 if ($year eq "" && $authors ne "" && $title eq "" && $journal ne "" && $firstpage eq "");
   if ($legit==1) {
    print "$patent\t$npline __zqxGROBIDzqx__\n";
   } else {
    print "***********************USELESS***************** $npline\n" if ($debug==11);
    print "777$patent\t$surname\t$year\n" if ($surname ne "" && $year ne "" && $debug==777);
   }
  }
 }

sub clear_fields {
  $volume = "";
  $year = "";
  $issue = "";
  $firstpage = "";
  $lastpage = "";
  $journal = "";
  $authors = "";
  $title = "";
  $editor = "";
  $surname = "";
  $firstname = "";
  $middlename = "";
  $note = "";
}

while (<>) {
 #print;
 chop;

 #if it's a new patent, change the patent # and blank out everything
 #if (/^__US([A-Z]*\d+)/ || /^([A-Z]*\d+)/) {
 if ($new_patent_next_line==1 && /^(\S+)/) {
 #print "\n\nTHIS LINE GOTTA BE A PATENT!\n$_\n";
 ##if (/^(__US[A-Z]*\d+)/) {
  #print "NEW PATENT $1\n";
  print STDERR "\n\nnew patent\n" if $debug==1;
  $patent = $1;
  clear_fields();
  $inarticle = 0;
  $new_patent_next_line = 0;
 }
 if (/^<div id=.*>/) {
 #print "NEXT LINE WILL BE A PATENT!\n$_\n";
 $new_patent_next_line = 1;
}
 # if a new listbibl, we're in a new article. 
 if (/<biblStruct *>/) {
  # if we were in an article, print out what we had
  print_article();
  $inarticle = 1;
  clear_fields();
  print STDERR "\nnew article\n" if $debug==1;
 }
 # at end of the record, print any match we have
 if (/<\/TEI>/) {
  print STDERR "end of record\n" if $debug==1;
  # if we were in an article, print out what we had
  print_article();
  $inarticle = 0;
  clear_fields();
 }
 # add editors as authors
 if (/<editor>(.*)<\/editor>/) {
  $editor = $1;
  print STDERR "new editor as author>$editor<\n" if $debug==1;
  if (!($editor eq "")) {
      $authors.= " and " if !($authors eq "");
      $authors.= $editor; 
  }
 }
 # we have an author to add to the list
 if (/<persName.*surname>(.*)<\/surname>/) {
  print STDERR "new author\n" if $debug==1;
  $surname = $1;
  if (/first\">([^\/]*)<\/forename/) {
   $firstname = $1;
  }
  if (/middle\">([^\/]*)<\/forename/) {
   $middlename = $1;
  }
  $authors.= " and " if !($authors eq "");
  $authors.= $surname;
  $authors.= ", " . $firstname if !($firstname eq "");
  $authors.= " " . $middlename if !($middlename eq "");
  print STDERR "fname>$firstname<mid>$middlename<surname>$surname>FULLNAME>$authors\n" if $debug==1;
 }
 if (/<title level=\"m\".*>(.*)<\/title>/) {
  if (!$journal) {
      $journal = $1;
  }
  else {
      $journal.= " $1";
  }
  print STDERR "journal>$journal<\n" if $debug==1;
 }
 if (/<title level=\"j\">(.*)<\/title>/) {
  if (!$journal) {
      $journal = $1;
  }
  else {
      $journal.= " $1";
  }
  print STDERR "journal>$journal<\n" if $debug==1;
 }
 if (/<title level=\"a\" type=\"main\">(.*)<\/title>/) {
  $title = $1;
  print STDERR "title>$title<\n" if $debug==1;
 }
 if (/date type=\"published\" when=\"(\d\d\d\d)/) {
  $year = $1;
  print STDERR "year>$year<\n" if $debug==1;
 }
 if (/<biblScope unit=\"volume\">(\d+)<\/biblScope>/) {
  $volume = $1;
  print STDERR "volume>$volume<\n" if $debug==1;
 }
 if (/<biblScope unit=\"issue\">(\d+)<\/biblScope>/) {
  $issue = $1;
  print STDERR "issue>$issue<\n" if $debug==1;
 }
 if (/<biblScope unit=\"page\">(\d+)<\/biblScope>/) {
  $firstpage = $1;
  print STDERR "page1>$firstpage<\n" if $debug==1;
 }
 #page range
 if (/<biblScope unit=\"page\" from=\"(\d+)\"/) {
  $firstpage = $1;
  print STDERR "page1>$firstpage<\n" if $debug==1;
  if (/to=\"(\d+)\"/) {
   $lastpage = $1;
  print STDERR "lastpage>$lastpage<\n" if $debug==1;
  }
 }
 if (/<note>(.*)<\/note>/) {
  $note = $1;
  print STDERR "note>$note<\n" if $debug==1;
 }
}
