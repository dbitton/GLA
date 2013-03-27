#!/usr/local/bin/perl -T

use strict;
use warnings;
use Storable qw(nstore);

my $number_of_descriptive_rows = 8;

my $input_file=                    "FeatureDB.List.GO.ListLoc.ListNew";
my $header_output_file =           "_FeatureList";
my $database_output_file        =  "_FeatureData";
my $database_all_genes_output_file="_AllGenesList";



open (INPUT,$input_file) || die (" File $input_file not found ! \n");
open (HEADER,">$header_output_file") || die (" File $header_output_file not found ! \n");

# The first lines contain an annotation of each feature

      my $line=<INPUT>;chomp($line);  # first line: short ID describing each feature
      print HEADER "$line\n";

      $line=<INPUT>;chomp($line); # second line: longer description of each feature
      my @labels=split(/\t/,$line);shift @labels;
      print HEADER "$line\n";

      $line=<INPUT>;chomp($line); # third line: scale of measurement (binary, ordinal, metric)
      my @scales=split(/\t/,$line);shift @scales;
      print HEADER "$line\n";

      $line=<INPUT>;chomp($line); # fourth line: class label. Features with the same class label belong to the same class.
      print HEADER "$line\n";

      $line=<INPUT>;chomp($line); # fifth line: source of feature. Where was the feature derived from?
      print HEADER "$line\n";

      $line=<INPUT>;chomp($line); # sixth line: author of feature. Who prepared the feature?
      print HEADER "$line\n";

      $line=<INPUT>;chomp($line); # seventh line: last update of feature. When was the feature prepared / updated?
      print HEADER "$line\n";

      $line=<INPUT>;chomp($line); # 8th line: URL with a link explaining the feature (or "")
      print HEADER "$line\n";


close (HEADER);


my $database;
my @all_genes=();

while (my $line=<INPUT>) {
   chomp($line);
   my @elements=split/\t/,$line;
   my $ID=  uc(shift @elements);
   push @all_genes, $ID;
   for (my $j=0;$j<=$#elements;$j++) {
      if ($scales[$j] eq "Metric") {
	push @{$database->[$j]},$elements[$j];
	} 
      elsif ($scales[$j] eq "Binary") {
         if ($elements[$j] eq "1") {
	    push @{$database->[$j]},$ID;
	 } else {
	    if ($elements[$j] ne "0") {
	       print "Error, gene $ID, column $j \( $labels[$j] \) is not binary!\n";
	    }
	 }
      }
   }
}

close (INPUT);


my @db_pointers;
my @empty_array=();

for (my $i=0;$i<=$#scales;$i++) {  
     if (defined ($database->[$i])) {
	push @db_pointers, $database->[$i];
     } else {
	push @db_pointers, \@empty_array;	
     }
}

nstore(\@all_genes, $database_all_genes_output_file);
nstore(\@db_pointers, $database_output_file);
