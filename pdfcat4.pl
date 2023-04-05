#!/usr/bin/perl -w
use strict;
use feature ':5.10';
use File::Path;
use Cwd;

# combine all charts for all instruments
# adding a function for individual files

#*********************setup**************************
my $basepath="/home/harry/Music/charts/world/";
my $target="combined/";
my $loopcnt=0;
my $single = $ARGV[0];
say $single;

sub allfiles{
	#*******get sorted list of pdf files from current directory ******
	my $path = cwd;   #path to read from	
	my $file_type="\.pdf";
	opendir(TEMP,$path) || die "$path is not a valid directory: $!"; 
	my @tunes = grep(/$file_type/, readdir TEMP);	#Just pdf files
	my @sorted = sort { "\U$a" cmp "\U$b" } @tunes; #case insensitive
	my $cnt=0; 
	my $loopcnt=0;
	foreach my $tune (@sorted){
		my $btune = "Bb/".$tune ;
		$cnt = $cnt +1 if -e $btune;
		my $etune = "Eb/".$tune ;
		$cnt = $cnt +1 if -e $etune;
		my $bass = "Bass/".$tune ;
		$cnt = $cnt +1 if -e $bass;
		
		# write combined pdf only if all the parts exist
		if ($cnt =>3){
			$loopcnt=$loopcnt+1;
			#system ( "pdfunite $tune $btune $etune $bass $target$tune");
			#system ("pdftk $tune $btune $etune $bass cat output $target$tune");
			$cnt=0;	
		}
		
	}
	 print "$loopcnt/$#tunes charts successfully merged";

}
 allfiles();



