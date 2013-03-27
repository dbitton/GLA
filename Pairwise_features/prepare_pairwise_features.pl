#!/usr/local/bin/perl -T

use strict;
use warnings;
use Storable qw(nstore);



########### two type of rel data sets:

# store value: missing or not!
# 1) member, positive members are enough, values not in set are assumed to be negative
# 2) value, genes not in set are assumed to be missing




#my $relation_file="Raw/prot2hcaptureortnew.txt";
#my $hash_name="../_hash_data_P-P-IA-cerevisiae";

my $relation_file="Raw/prot_pbonly.txt";
my $hash_name="../_hash_data_P-P-IA";

open (REL_FILE,$relation_file) || die (" File $relation_file not found ! \n");

my %hash=();

while (my $line=<REL_FILE>) {
   chomp($line);
   my @el=split(/\t/,$line);
   if ($#el==1) {
       $hash{uc($el[0])}{uc($el[1])}=1;
   } elsif ($#el==2) {
       $hash{uc($el[0])}{uc($el[1])}=$el[2];
   }
}

nstore(\%hash, $hash_name);
