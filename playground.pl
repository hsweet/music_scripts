#!/usr/bin/perl -w
#use strict;
use feature ':5.10';
use strict;

use File::Basename;
my $basepath = "/home/harry/Music/charts/world/combined/";
# get the directory path for the compressed files
my $out_dir = "$basepath/compressed/";
chdir($basepath);


my $tune_type = "\.pdf";
opendir(my $dh, $basepath) || die "Cannot open directory: $!";
my @files = readdir($dh);
closedir($dh);
#add bit to filter for only pdfs
foreach my $file (@files){
	  my $in_file = $basepath . $file;
	  my $out_file = $out_dir . $file;
	  say $in_file;
	  say $out_file;
	  system("qpdf --stream-data=compress --object-streams=generate --linearize \"$file\" \"$out_file\"");
	}


__END__ 
 


__END__


qpdf --stream-data=compress --object-streams=generate --linearize input.pdf output.pdf
find .-type f -name "*.pdf" -exec qpdf --compress-streams=y {} {}_compressed.pdf \;


find /path/to/directory -type f -name "*.pdf" -exec qpdf --compress-streams=y {} {}_compressed.pdf \;
find . -type f -name "*.pdf" -exec qpdf --compress-streams=y {} {}_compressed.pdf \;
find /path/to/original/files -type f -name "*.pdf" -exec sh -c 'qpdf --compress-streams --replace-input "$1" "compressed/$(basename "$1")"' sh {} \;



 
my $line = "melody = \\relative c {";
$line =~ s/relative c(?=\s)/relative c,/g;
$line =~ s/relative c'(?=\s)/relative c/g;
$line =~ s/relative c''(?=\s)/relative c'/g;
print $line;  # Output: melody = \relative c { 


#$target = "Eb";
$line = "melody = \\relative c'' {";
say $line;
 #if ($target eq "Eb") {
$line =~s\c.\c\g;
#}
say $line;
#$x=`ls -lsad`;
#say $x;

#$y=system ("cat something");
#say $y;

# **************  send array to function
my @t=qw(this that other);


__END__ 
sub f{
   (my @a)=@_;
    return @a;	
	}
	
my @x=f('fish','dog');
print @x;

print f(@t);



#********************************
my $str = "I am a boatb";
$str=~ s/boat/goat/ if $str=~/b$/ ;
#print $str;
