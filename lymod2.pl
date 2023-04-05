#!/usr/bin/perl -w
use strict;
use File::Path;
use Cwd;

my ($file_type, $path, @basename, $midistring);
mkpath(["changed"],1);
 
my $path="/home/harry/Music/charts/world";
chdir ($path);

my $file="oldpartletters.txt";

open(MYFILE, $file ) || die "opening $file: $!";
   	my @files=<MYFILE>;
close(MYFILE);
print @files;

#my $cnt=0;	
foreach my $file(@files){
#	    $cnt++;
	    chomp $file;
		open(MYFILE, $file ) || die "opening $file: $!";
   			my @text=<MYFILE>; 
		close(MYFILE);  
     
        @basename = split(/\./, $file);
         
      	 
		open(OUT, ">changed/$file");	#output is to a folder called "Changed" one level deeper in tree
			foreach my  $_(@text){
                s/\^\\markup { \\box .*}//;
                print OUT;  
                if (/\\time/){
                    print OUT "  \\set Score.markFormatter = #format-mark-box-alphabet\n" ;
                }
                if (/\\repeat volta/){
                    print OUT "  \\mark \\default\n";
                }
                
		}
		close(OUT);
}


 
 
