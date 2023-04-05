#!/usr/bin/perl -w
use strict;
use feature ':5.10';
use File::Path;
use Cwd;

#*********************setup*************************
#my $tune = "740";
#$tune=$tune.".pdf";

my $basepath="/home/harry/Music/charts/world";
chdir ($basepath);
say cwd;

open (FH, "combined/crappy/crappy.txt" ) || die $!;
my @tunes = <FH>;
close (FH);

foreach my $tune (@tunes){
	chomp $tune;
	say $tune;
	system("pdftk $tune Bb/$tune Eb/$tune Bass/$tune cat output combined/$tune");
	}

#system ("pdftk $tune Bb/$tune Eb/$tune Bass/$tune cat output combined/crappy/$tune");
#print("pdftk $tune Bb/$tune Eb/$tune Bass/$tune cat output combined/$tune");
