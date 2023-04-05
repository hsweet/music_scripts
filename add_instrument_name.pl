#!/usr/bin/perl -w
use strict;
use feature ':5.10';
use File::Path;
use Cwd;

my $path="/home/harry/Music/charts/world";
chdir (epath);
my $path = cwd;   #path to read from
#say $path;

my @folders = qw(Bb Eb Bass f);

#quickie to add an instrument name to all the old charts missing that

foreach my $folder (@folders){
	
	chdir $path."/".$folder;
	say "--------------";
	say getcwd(); 
	my @tunes = `grep -L 'instrument' *.ly`;
	say "--------------";
	print @tunes;

	foreach my $tune (@tunes){
		 system ("sed -i  '/title/a instrument = \"Violin\"' $tune") ;
	}

	foreach my $tune (@tunes){
		system("lilypond $tune");
		}

}
