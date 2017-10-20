#BLAST.pl by Xiuge Chen

#perl version of BLAST

#this program will ask the length of the window k, the threshold t, and the name of the 
#query file and Database file

#this program will put the characters of D and Q in arrays, find and extract the location
#of each different k-mer in Query data, scan left and right to find the HSPs,
#list of all occurrences of each distinct k-mer in both the database and query 
#and build up a list of all occurrences of each distinct HSP in both the data and
#query string. Finally report the content, length, positions and origin of the substrings
#with HSP to the terminal

#!/pkg/bin/perl -w

use diagnostics;

#get the length of the window k from the terminal
print "Input the length of the window: \n";
$k = <>;			#the value of the length of the window
chomp $k;

#get the threshold t from the terminal
print "Input the threshold t: \n";
$t = <>;			#the value of the threshold t
chomp $t;

#get the name of the query file from the terminal
print "Input the name of the query file\n";
$queryName = <>;
chomp $queryName;

open (IN, $queryName);

#extract the location of the first occurrence of that 4-mer in Q
$Q = <IN>;
chomp $Q;

print "\nquery string: \n$Q\n";

@stringQ =  split(//, $Q);	#put the characters of Q in arrays

%kmerQ = ();	# This initializes the hash called kmer.
$i = 1;

#fill the k-mer hash with contents in Q
while (length($Q) > $k) {
	$Q =~ m/(.{$k})/; 
  	if (! defined $kmerQ{$1}) {     
    	$kmerQ{$1} = [$i];       
  	}
  	else { 
  		push (@{$kmerQ{$1}}, $i)
  	}
	$i++;
  	$Q = substr($Q, 1, length($Q) -1);
}

#get the name of the database file from the terminal
print "\nInput the name of the string data file\n";
$stringName = <>;
chomp $stringName;

open (IN, $stringName);

$/ = "";

#extract the location of the first occurrence of that 4-mer in S
while ($S = <IN>) {
	chomp $S;
	
	$Sfix = $S;
	
	print "\nstring: $Sfix\n";
	
	@stringS =  split(//, $S);	#put the characters of S in arrays
	
	%stringHashS = ();
	%stringHashQ = ();

	%kmerS = ();	# This initializes the hash called kmer.
	$i = 1;
	
	#fill the k-mer hash with contents in D
	while (length($S) > $k) {
  		$S =~ m/(.{$k})/; 
  		if (! defined $kmerS{$1}) {     
    		$kmerS{$1} = [$i];       
  		}
  		else { 
  			push (@{$kmerS{$1}}, $i)
  		}
		$i++;
  		$S = substr($S, 1, length($S) -1);
	}

	foreach $kmerSkey (sort keys(%kmerS)) {
 		
 		foreach $kmerQkey (sort keys(%kmerQ)) { 
 			
 			#when we find the matching kmers
 			if ($kmerQkey eq $kmerSkey) {
 				
 				#scan left and right to find the max number of substring
 				foreach $ScanS (@ {$kmerS{$kmerSkey}}) {
 				
 					foreach $ScanQ (@ {$kmerQ{$kmerQkey}}) {
 					
 						$L = $k;
 						
 						#find the common subsequence from right
 						for ($i = $ScanS - 2, $j = $ScanQ - 2; $stringS[$i] eq $stringQ[$j]; $i--, $j--) {
 							$L++;
 						}
 						#find the common subsequence from left
 						for ($m = $ScanS + $k - 1, $n = $ScanQ + $k - 1; $stringS[$m] eq $stringQ[$n]; $m++, $n++) {
 							$L++;
 						}
 						
 						#the common subsequence found is longer than threshold
 						if ($L > $t) {
 							$HSP = substr($Sfix, $i + 1, $L);
 							
 							#find a new HSP in D
 							if (! defined $stringHashS{$HSP}) {
 								$stringHashS{$HSP} = [$i + 2];
 								print "HSP with length $L: $HSP\n";
 							}
 							#the HSP found is already found in D before
 							else { 
 								$exist = 0;
 								#determine whether this HSP are found in a new position
 								foreach $position (@ {$stringHashS{$HSP}}) {
 									if (($i + 2) == $position) {
 							  			$exist = 1;
 									}
 								}
 								#if the HSP appears in a new position, store the position
 								if ($exist == 0) {
 									push (@ {$stringHashS{$HSP}}, $i + 2);
 								}
 							} 
 							
 							#find a new HSP in Q
 							if (! defined $stringHashQ{$HSP}) {
 								$stringHashQ{$HSP} = [$j + 2];
 							}
 							#the HSP found is already found in Q before
 							else { 
 								$exist = 0;
 								#determine whether this HSP are found in a new position
 								foreach $position (@ {$stringHashQ{$HSP}}) {
 									if (($j + 2) == $position) {
 							  			$exist = 1;
 									}
 								}
 								#if the HSP appears in a new position, store the position
 								if ($exist == 0) {
 									push (@ {$stringHashQ{$HSP}}, $j + 2);
 								}
 							} 
 						}
 					}
 				}
 			}
 		}
	}
	
	#get and print the positions of occurrence of HSP
	foreach $HSP (sort keys(%stringHashS)) {
		$occrsS = join(', ' , @ {$stringHashS{$HSP}});
		$occrsQ = join(', ' , @ {$stringHashQ{$HSP}});
 		print "The occurrences of string $HSP are in positions $occrsS in Database string, $occrsQ in Query string\n";
	}
}