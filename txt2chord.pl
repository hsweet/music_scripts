#!/usr/bin/perl -w
use strict;
use feature ':5.10'; 

#  txt2chordii.pl
#  
#  Copyright 2019 root <root@harry-desktop>
#  
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#  
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
 

=pod
 Script to read text file in the form of chords above lyrics and convert
 to chordpro/chordii format with chords inline.
  
 Optional command line arguments = file to read, file to write
 if no write file given, uses input file base name
 third optional switch -c will (eventually) run chordpro and compile chart
 I could add another switch to transpose chart, etc.
 
 pdf files can be converted to proper input file via pdftotext -layout filename
 It might be necessary to do some minimal cleanup on the input.
 
 tesseract or another ocr program can make a text file from an image file
 image | tesseract | text | txt2chordii | evince (pdf viewer)
=cut
 

my $file = $ARGV[0] || "sample.txt";
my $title = ucfirst $file;			# title = file base name
$title =~  s/\.\w+//;		# drop extension
my $out_file= $ARGV[1] || $title.".cho";
$title = "{t:$title}";
#say $out_file;
my (@chordline, @verseline, @pos, @lines) = ();
my ($i,$v)=0;   #loop counter

open(MYFILE, $file ) || die "opening $file: $!";
   	my @song=<MYFILE>;
close(MYFILE);
 
sub merge{
	my $i=0;
	my @p=();  			#position of chords
	# chord, verse
	my ($c, $v) =  @_; 		#dereference
	my @c=@{$c};
	my @v=@{$v};
   
	foreach (@c){			# locate chords
		if (/\w/){push @p,($i)}
		$i++;  
		}
	 # ? line gets longer by 1 for each chord added
	 # but splice adds extra, it works
	 
	 $i =0;  # now $i is the fudge factor
	 foreach (@p){
		 my $chord = $c[$_];
		 splice(@v, $_+$i*2, 0, "[$chord]");
		 $i++
		 }
	return @v;
}

#  makes an array of chords or verses, ex qw(c v c v v v)
#  blank lines are passed on unchanged
foreach (@song)	{   
	$i++;
	if (/\s{3,}  			# three or more adjacent spaces
		|
		^[A-G]\w{0,2}$   	# Chords like F or Fm7
		/gmx)				
	{
		 push @lines, 'c';
	}else{
		push @lines, 'v';
	}
}
my $len = $#lines; 
$i=0;

open (MYFILE, ">$out_file") || die "Can't open $out_file: $1";
say MYFILE $title; 
print MYFILE "\n";
###################### Merge and print############## 
 # last line will always be verse, even if it contains chords
for ($a=0; $a<$len; $a++){
	# if line = verse && next = chords ==> ignore
	if ($lines[$i] eq "v" && $lines[$i+1] eq "c" ){
	#   verse is followed by verse
	}elsif ($lines[$i] eq $lines[$i+1] ){	 
		print MYFILE $song[$i+1];
	}else{  					# chord line, merge with next
		chomp $song[$i];
		my @chord =  split(/ /, $song[$i]);
		my @verse = split(//, $song[$i+1]);
		print MYFILE merge(\@chord, \@verse);	
			}
 $i++;
 }
close (MYFILE);

####################  Make pdf chart using chordii ###############
##  probably should use some sort of exception catching
my $rvalue = system ("chordpro $out_file");
$out_file =~  s/\.\w+//;
#say $out_file;
$out_file = $out_file.".pdf";
if ($rvalue == 0){
	#say "Successful"
	system ("evince $out_file &")  #need basename
	}
