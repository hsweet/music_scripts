#!/usr/bin/perl -w
use 5.010;
use strict;

my $path="/home/harry/Music/charts/world";
chdir ($path);
my $file= "Adio.ly";

my ($start, $end, @chords);

open (TUNE , $file) || die "opening $file: $!";
my @tune= <TUNE>;
close (TUNE);

#################find title, time signiture
my @title= grep(/ title/, @tune);  
my @time= grep(/\\time /, @tune);
my $filelength = @tune;
$title[0]=~s/\"|title=|\s+//g;
$time[0]=~s/\\time|\s+//g;

#################get chords#################	
my $cnt=0;   #look for beginning of harmony section
while ($cnt<$filelength){ 	
	if ($tune[$cnt] =~ /harmonies/){
		  $start= $tune[$cnt-1];    #find the start of the chords
		  until ($tune[$cnt] =~/}/){ #print until end of chord section
		  $cnt++;
		  push (@chords, $tune[$cnt-1]);
	  } 
  }
	$cnt++;
}

################clean chords for display#################3
foreach (@chords){
	chomp;
	s/(\d)|\W|\s+//g;
	#say $1;
	say;
	print" | "; 
	}



#d1 would be a d chord, value of 4

say $title[0];
say @time;
#print join " / ", @chords;
