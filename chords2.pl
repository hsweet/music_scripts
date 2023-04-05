#!/usr/bin/perl -w
use 5.010;
use strict;
use File::Path;
use Cwd;

######################################################
my ($file_type, $path,$filelength, @timesignature, @text, @titles, @chord, @chord);
######################################################
#mkpath(["changed"],1);  make new folder

my $path="/home/harry/Music/charts/world";
chdir ($path);

opendir(TEMP,$path) || die "$path is not a valid directory: $!";
my @files=sort grep(/\.ly$/, readdir TEMP);	#Just lily files
#say @files;
my $howmanytunes= @files;
say "$howmanytunes tunes";

###################### read & parse each file ##########

foreach my $file(@files){
	open(MYFILE, $file ) || die "opening $file: $!";
    @chord=<MYFILE>;
   	close(MYFILE);
   	#################find title, time signiture
		print "\n\n";
		my @title= grep(/ title/, @chord);
		@timesignature= grep(/\\time /, @chord);
		$filelength = @chord;
		$title[0]=~s/\"|title=|^\s+//g;
		chomp $title[0];
		$timesignature[0]=~s/\\time|\s+//g;
		say"$title[0] $timesignature[0]";


#################get chords#################
my $cnt=0;   #look for beginning of harmony section
	while ($cnt<$filelength){
		if ($chord[$cnt] =~ /harmonies =/){
			  my $start= $chord[$cnt-1];    #find the start of the chords
			  until ($chord[$cnt] =~/^$/){   #print until end of chord section
			  $cnt++;
			  ###############pull out chords and times#############
			  if ($chord[$cnt]=~ /(\d)/g ){
				  my $num=$1;   # $1=length of chord, 2 from d2 etc
				  $chord[$cnt]=~s/\W*//;
				  #$chord[$cnt]=~s/r.\*/---/g;  #repeats
				  $chord[$cnt]=~s/\*|://g;
				  $chord[$cnt]=~s/\d|\s+//g;
				  print $chord[$cnt] ;
				 print "-" . beats_per_measure($timesignature[0], $num) . " ";
				}
			  #############filter chords###############
			}
		} 
	$cnt++;
	}
}
sub beats_per_measure{
	my ($timesignature, $length) = @_;
	my $beats=-1;
	my $measures = -1;
	my ($bpm, $note_getsbeat)=split ("/",$timesignature);
	given ($timesignature){
		when ($timesignature eq "2/4" and $length == 2){ $beats=2; $measures=1}
		when ($timesignature eq "2/4" and $length == 4){ $beats=1; $measures=1/2}
		when ($timesignature eq "4/4" and $length == 1){ $beats=4; $measures=1}
		when ($timesignature eq "4/4" and $length == 2){ $beats=2; $measures= 1/2}
		when ($timesignature eq "4/4" and $length == 4){ $beats=1; $measures= 1/4}
		when ($timesignature eq "3/8" and $length == 4){ $beats=2; $measures= 2/3}
		when ($timesignature eq "3/8" and $length == 8){ $beats=1; $measures= 1/3}
		when ($timesignature eq "3/4" and $length == 2){ $beats=2; $measures= 2/3}
		when ($timesignature eq "3/4" and $length == 1){ $beats=1; $measures= 1/2}
		}
		#print "-" x $beats;
        #print "|" if $beats == $bpm;
		 
	return $beats;# if $beats>0;
	}
__END__

Time	1		2		4		8

2/4		4b/2m	2b/1m	1b/1/2m	x
3/4		x		2b/2/3m	1b/1/3m	x
4/4		4b/1m	2b/1/2m	1b/1/4m	x
3/8		x		x		2b/2/3m	1b/1/3m

 #chomp $chord[$cnt];
		  #$chord[$cnt]=~ s{
		 #(\s*)
		  #r+  
	      # }[]gsx;
Based on an old script
Harry Sweet, July 2001


