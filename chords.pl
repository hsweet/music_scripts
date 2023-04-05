#!/usr/bin/perl -w
use 5.010;
use strict;
use File::Path;
use Cwd;

######################################################
my ($file_type, $path,$filelength, @time, @text, @titles, @tune, @chords);
######################################################
#mkpath(["changed"],1);  make new folder

####################### get all the lily files ######3##
my $path="/home/harry/Music/charts/world";
chdir ($path);


opendir(TEMP,$path) || die "$path is not a valid directory: $!";
my @files=sort grep(/\.ly$/, readdir TEMP);	#Just lily files
my $howmanytunes= @files;
say "$howmanytunes tunes";

###################### read & parse each file ##########

foreach my $file(@files){
	open(MYFILE, $file ) || die "opening $file: $!";
    @tune=<MYFILE>;
   	close(MYFILE);
   	#################find title, time signiture
		print "\n" ."-" x 60 . "\n";
		my @title= grep(/ title/, @tune);
		@time= grep(/\\time /, @tune);
		$filelength = @tune;
		$title[0]=~s/\"|title=|^\s+//g;
		chomp $title[0];
		$time[0]=~s/\\time|\s+//g;
		say"$title[0] $time[0]";


#################get chords#################
my $cnt=0;   #look for beginning of harmony section
my $measures=0; 
	while ($cnt<$filelength){
		if ($tune[$cnt] =~ /harmonies =/){
			  my $start= $tune[$cnt-1];    #find the start of the chords
			  until ($tune[$cnt] =~/^$/){   #print until end of chord section
			  $cnt++;
=rests
			  ###############figure out rests##########
  rests are often on same line with chord (d2 r4*2)
   /\w\s+r\d+/ matches mixed lines, rests + chords
  which could be rest chord rest, or chord rest chord etc
  This routine should add \n after every mixed line and send
  it foward for further processing. 
=cut 
			     $tune[$cnt]=~s/\w\s/\n/;	#one chord/rest per line
			     #print $tune[$cnt] if($tune[$cnt]=~/\w\s+r\d+/);
			     print $tune[$cnt];
			  ###############pull out times#############
			  if ($tune[$cnt]=~ /(\d)/g ){
				  my $num=$1;   #lilypond time i.e. 1=whole note, 2=1/2
				  $tune[$cnt]=~s/\W*//;
				  $tune[$cnt]=~s/r.\*/---/g;  #rests???
				  $tune[$cnt]=~s/\*|://g;
				  $tune[$cnt]=~s/[1-6,8,9]|\s+//g; 
				  #print $tune[$cnt];		#print the chord
				  #sub called once per chord!
				  #gets sent time of piece and whole, half, quater note 
				  $measures = beats_per_measure($time[0], $num)+ $measures;
				  #match any whole number of measures.
				  #print "|" if ($measures !~ /\./);
				}
			  #############filter chords###############
			   
			}
		} 
	$cnt++;
	}
}
sub beats_per_measure{
	my ($time, $length) = @_;
	my $beats=-1;
	my $measures = -1;
	my ($bpm, $note_getsbeat)=split ("/",$time);
	given ($time){
		when ($time eq "2/4" and $length == 2){ $beats=2; $measures=1}
		when ($time eq "2/4" and $length == 4){ $beats=1; $measures=1/2}
		when ($time eq "3/4" and $length == 2){ $beats=2; $measures= 2/3}
		when ($time eq "3/4" and $length == 4){ $beats=1; $measures= 1/3}
		when ($time eq "4/4" and $length == 1){ $beats=4; $measures=1}
		when ($time eq "4/4" and $length == 2){ $beats=2; $measures= 1/2}
		when ($time eq "4/4" and $length == 4){ $beats=1; $measures= 1/4}
		when ($time eq "3/8" and $length == 4){ $beats=2; $measures= 2/3}
		when ($time eq "3/8" and $length == 8){ $beats=2; $measures= 1/3}
		}
		#print "-" x $beats;
		return $measures; 
	}
__END__

Time	1		2		4		8

2/4		4b/2m	2b/1m	1b/1/2m	x
3/4		x		2b/2/3m	1b/1/3m	x
4/4		4b/1m	2b/1/2m	1b/1/4m	x
3/8		x		x		2b/2/3m	1b/1/3m

 #chomp $tune[$cnt];
		  #$tune[$cnt]=~ s{
		 #(\s*)
		  #r+  
	      # }[]gsx;

