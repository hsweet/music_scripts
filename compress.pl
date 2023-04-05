#!/usr/bin/perl -w
#use strict;
use feature ':5.10';
use strict;

#use File::Basename;
my $basepath = "/home/harry/Music/charts/world/combined/";
my $out_dir = "$basepath/compressed/";
chdir($basepath);

my $tune_type = "\.pdf";
opendir(my $dh, $basepath) || die "Cannot open directory: $!";
my @files = readdir($dh);
closedir($dh);

foreach my $file (@files){
	if ($file=~/pdf/){
		say $file;
		my $in_file = $basepath . $file;
		my $out_file = $out_dir . $file;   
	    #system("qpdf --stream-data=compress --object-streams=generate --linearize \"$file\" \"$out_file\"");
}
}
