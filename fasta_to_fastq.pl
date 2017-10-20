#fasta_to_fastq.pl by Xiuge Chen

#the function of this program is to convert the fasta format file to fastq format.

#!/usr/bin/perl
use strict;

#get the filename from the command line
my $file = $ARGV[0];
open FILE, $file;

my ($header, $sequence, $sequence_length, $sequence_quality);
while(<FILE>) {
        chomp $_;
        
    #find the name line and do conversion, print
    if ($_ =~ /^>(.+)/) {
        if($header ne "") {
            print "\@".$header."\n";
            print $sequence."\n";
            print "+"."\n";
            print $sequence_quality."\n";
        }
                
        #reset all the variables
        $header = $1;
		$sequence = "";
		$sequence_length = "";
		$sequence_quality = "";
    }
        
    #For the content line store its contents and quality.
	else { 
		$sequence .= $_;
		$sequence_length = length($_); 
		for(my $i=0; $i<$sequence_length; $i++) {$sequence_quality .= "I"} 
	}
}

close FILE;
print "\@".$header."\n";
print $sequence."\n";
print "+"."\n";
print $sequence_quality."\n";

