#fastq_to_fasta.pl by Xiuge Chen

#the function of this program is to convert the fastq format file to fasta format

#!/usr/bin/perl

use strict;
use warnings;

#get the filename from the command line
my $filename = $ARGV[0]; 

open(my $fh, '<', $filename)
  or die "Could not open file '$filename' $!";

my $line_num  = 0;
#change the fastq file to fasta file
while (my $line= <$fh>) {
    if ($line_num % 4 == 0) {
        print(">". substr($line, 1));
        $line_num = 0;
    }
    if ($line_num  == 1) {
        print($line);
    }

    $line_num++;
}