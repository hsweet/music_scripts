#!/usr/bin/perl
use strict;
use warnings;
use feature qw(say);
use File::Path qw(make_path remove_tree);

=pod
Transpose recently changed lilypond files:

useage ...  transpose.pl [number of days to look back]
ex. transpose.pl 7 looks back a week

This function first calls the tunes()to get a list of all the 
Lilypond files that need to be processed. Then, it loops through that
list and uses lilypond to create PDFs for each instrument 
(Bb, Eb, and Bass) in their respective folders.

Next, it loops through the list again and creates a combined PDF file 
for each Lilypond file using pdftk.  Finally, it opens the finished
pdf in nautilus (on Linux)

Bf Clarinet C==>D		Ef Horn C==>A   Bass just change clef
=cut

my $cutoff_age = $ARGV[0] || 5;
my $basepath = "/home/harry/Music/charts/world";
chdir($basepath);
my @instruments = qw(Bb Eb Bass);

# sub order = transpose(), makepdf(), compress()
#  Do not automatically write over existing transposed instrument files!
say "Is this a new or modified C instrument chart?.. y/n \n";
my $is_newchart = <STDIN>;
chomp $is_newchart;
if ($is_newchart eq "y"){
		foreach my $instrument (@instruments) {
			transpose($instrument);
		}  
	} 
	

#*******************************************
my $combined_pdf = makepdf(@instruments);
#say "\n value of combined pdf sub is $combined_pdf";

if ($combined_pdf) {
	# works only if makepdf() returns a value
    #say "Finished generating $combined_pdf.";
   #system("xdg-open combined/$combined_pdf");
} else {
   # say "Failed to generate the combined PDF.";
}

compress();

sub basename{
	my ($tune) = @_;
	my @basename= split(/\./,$tune);
    my $pdf = "$basename[0].pdf";
    return $pdf;
	}

sub age {
    my ($file) = @_;
    unless ($file) {
        print "No files found for processing. Exiting...\n";
        exit 0;
	}
    my @is_recent = stat($file);
    my $mtime = $is_recent[9];
    my $days_old = ((time) - $mtime) / 86400;
    return $days_old;
}
	
sub tunes {
    my $tune_type = "\.ly";
    opendir(my $dh, $basepath) || die "Cannot open directory: $!";
    my @files = readdir($dh);
    closedir($dh);

    my @tunes2use;
    foreach my $tune (@files) {
        if ($tune =~ /$tune_type/ && age($tune) < $cutoff_age) {
            push @tunes2use, $tune;
        }
    }
    return @tunes2use;  #lilypond files
}

sub transpose {
    my ($instrument) = @_;
    say "\nTransposing chart\n";
    my $target;
    if ($instrument eq "Bb") {
        $target = "d";
    } elsif ($instrument eq "Eb") {
        $target = "a";
    } elsif ($instrument eq "Bass") {
        $target = "bass";
    }

    make_path($instrument);

    my @files = tunes();
    foreach my $tune (@files) {
        my $input_file = "$basepath/$tune";
         #if (!-e "$basepath/$instrument/$tune"){
           my $output_file = "$basepath/$instrument/$tune";
	    #}

        open(my $input_fh, "<", $input_file) || die "Cannot open file $input_file: $!";
        my @text = <$input_fh>;
        close($input_fh);
        say "$instrument/$tune...";
        open(my $output_fh, ">", $output_file) || die "Cannot create file $output_file: $!";
        foreach my $line (@text) {
        $line =~ s/Violin/$instrument/;

            if ($target ne "bass") {
                $line =~ s/\\score \{/\\score \{\\transpose c $target/;
                if ($target eq "a") {		 
					$line =~ s/relative c(?=\s)/relative c,/g;
					$line =~ s/relative c'(?=\s)/relative c/g;
					$line =~ s/relative c''(?=\s)/relative c'/g;		              
                }
            } elsif ($target eq "bass") {
                $line =~ s/clef treble/clef bass/;
                $line =~ s/relative c'*/relative c/;
            }
            print $output_fh $line;
        }  #foreach
        close($output_fh);
    }
}

sub makepdf {
    my @tunes = tunes();
    #make pdfs
    say "-" x 60;
    say "\nCompiling Lilypond Files";
    foreach my $tune (@tunes){
        chdir "$basepath/Bb";
        my $x= `lilypond -s $basepath/Bb/$tune`;
        chdir "$basepath/Eb";
        $x= `lilypond -s $basepath/Eb/$tune`;
        chdir "$basepath/Bass";
        $x= `lilypond -s $basepath/Bass/$tune`;
    }
    say "\nCombining PDFs";
    #combine pdfs
    foreach my $tune (@tunes){ 
        my $pdf=basename($tune);  
        chdir $basepath; 
        system("pdftk $pdf Bb/$pdf Eb/$pdf Bass/$pdf cat output combined/$pdf")
    }
    #return 1;
    #display finished files
    if (fork() == 0) {
        exec("nautilus $basepath/combined");
        exit;
    }
}

sub compress{
    my @files = tunes();
    say "-" x 60;
    say "Compressing files .. ";
    say "-" x 60;
    my $in_path = "$basepath/combined";
    my $out_path = "$basepath/combined/compressed";
    for (@files){
		s/\.ly/\.pdf/;
		my $in_file = "$in_path/$_";
		my $out_file = "$out_path/$_";
		say "$in_file";
		say "$out_file";
		system("qpdf --stream-data=compress --object-streams=generate --linearize \"$in_file\" \"$out_file\"");
	}
}

