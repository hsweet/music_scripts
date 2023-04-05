#!/usr/bin/perl -w
use strict;
use feature ':5.10';
use File::Path;
use Cwd;

# Set up command line options
use Getopt::Long;
my $chart_directory = "/home/harry/Music/charts/world";
my $days_to_look_back = 4;
GetOptions(
    "directory=s" => \$chart_directory,
    "days=i" => \$days_to_look_back,
);

# Transpose and create PDFs for each instrument
transpose_and_create_pdfs("Bb");
transpose_and_create_pdfs("Eb");
transpose_and_create_pdfs("Bass");

# Combine PDFs
combine_pdfs();

# Display finished files
system("nautilus $chart_directory/combined");

#------------------ Subroutines ------------------

sub transpose_and_create_pdfs {
    my ($instrument) = @_;

    my $transpose;
    if ($instrument eq "Bb") {
        $transpose = "d";
    }
    elsif ($instrument eq "Eb") {
        $transpose = "a";
    }
    elsif ($instrument eq "Bass") {
        $transpose = "bass";
    }

    # Create directory for instrument
    my $instrument_directory = "$chart_directory/$instrument";
    unless (-d $instrument_directory) {
        mkdir $instrument_directory or die "Could not create directory: $!";
    }

    # Get list of files to process
    my @files = get_recent_files($chart_directory, $days_to_look_back);

    foreach my $file (@files) {
        # Process file
        print "Processing $instrument/$file...\n";

        open(my $fh_in, '<', "$chart_directory/$file") or die "Could not open file: $!";
        open(my $fh_out, '>', "$instrument_directory/$file") or die "Could not open file: $!";

        while (my $line = <$fh_in>) {
            # Transpose and modify file
            $line =~ s/Violin/$instrument/;  # For Bb and Eb add "instrument"

            if ($transpose ne "bass") {
                $line =~ s/\\score \{/
