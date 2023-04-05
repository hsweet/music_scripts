#!/usr/bin/perl
use strict;
use warnings;

my $file = shift;

# open the file
open(my $fh, '<', $file) or die "Could not open file '$file': $!";

# read the file into a string
my $file_contents = do { local $/; <$fh> };

# search for chords
my @chords = ($file_contents =~ m/<[A-G][b\#]?[m\+]?>/g);

# print the chords
print "Chords: @chords\n";
