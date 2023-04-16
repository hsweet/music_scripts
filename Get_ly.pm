package Get_ly;

use strict;
use warnings;

my $LEVEL = 1;

my $basepath = "/home/harry/Music/charts/world";

sub file_list{
	my $basepath = "/home/harry/Music/charts/world" 
	my $file_type="\.ly\$";
	opendir(TEMP,$basepath) || die "$basepath is not a valid directory: $!"; 
	my @tunes = grep(/$file_type/, readdir TEMP);	#Just pdf files
	my @sorted = sort { "\U$a" cmp "\U$b" } @tunes; #case insensitive
	return @sorted;
	}
	
 sub basename{
	my ($tune) = @_;
	my @basename= split(/\./,$tune);
    my $pdf = "$basename[0].pdf";
    return $pdf;
	}

#print &file_list();

1;
