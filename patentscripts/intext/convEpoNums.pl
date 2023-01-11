#!/usr/local/bin/perl

while (<>) {
	chomp;
	if (/^([^\t]+)\t([^\t]+)\t([^\t]+)\t(.*)$/) {
		$jurisdiction = $1;
		$patnum = $2;
		$suffix = $3;
		$blob = $4;
	}
	print "__$jurisdiction-$patnum-$suffix\n$blob\n\n";
}
