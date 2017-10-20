#RandDnaGenerator_LCS.pl by Xiuge Chen

#For the first part of this program, it will produce random DNA strings with the number
#of nucleotides and strings got from user.

#For the second part, this program will compute the longest common substring(LCS) among
#the first string and all the rest strings respectively, the objective function is:
#maximize{V * (#matches)}.

#the basic purpose for this program is to get the average LCS length among random strings
#in order to comparing it with the theoretic results we calculated in class.

#the result is surprising that the average LCS lengths in experiment are not even close
#to the lower bound of E(LCS) we calculated in the course, which is n/4. So in fact
#the expected length of the longest common subsequence for 2 random strings should be
#more than half the size of the strings, which is nearly from 0.54 to 0.72.

#!/usr/bin/perl

#get the name of output file from the terminal
print "What is the name of the output file?\n";
$rstrings = <STDIN>;
open (OUT, ">$rstrings");

#get the number of nucleotides to produce from the terminal
print "How many nucleotides for the string?\n";
$n = <>;
chomp $n;

#get the number of strings to produce from the terminal
print "How many strings you want to produce?\n";
$stringnum = <>;
chomp $stringnum;

#produce $stringnum strings with $n bases.
for($k = 0 ;$k <= $stringnum; $k++) {
	$numstring = ''; 
	$i = 0;
	while ($i < $n) {
		
		#produce initiate string with 0123 in random order
		$numstring = int(rand(4)) . $numstring; 
   		$i++;                                   
	}
	#replace 0123 with abcd in strings and assign them to the array used in compute
	$dnastring[$k] = $numstring;            
	$dnastring[$k]=~ tr/0123/actg/; 
}

$sum = 0;

chomp $dnastring[0];
@string1 =  split(//, $dnastring[0]);

#compute the LCS among the first string and all the rest strings respectively
for($k = 1; $k <= $stringnum; $k++) {
	
	chomp $dnastring[$k];
	@string2 =  split(//, $dnastring[$k]);
	
	#get the length of two strings that are compared
	$n = @string1;                 
    $m = @string2;
	
	#initiate the computing matrix
	$V[0][0] = 0;                  
	for ($i = 1; $i <= $n; $i++) {
   		$V[$i][0] = 0;
	}
	for ($j = 1; $j <= $m; $j++) {
   		$V[0][$j] = 0;
	}
   	
	for ($i = 1; $i <= $n; $i++) {      
 		for ($j = 1; $j <= $m; $j++) {
 		
 			#only care the matches, which is scored 1.
   			if ($string1[$i-1] eq $string2[$j-1]) {
   				$t = 1; 
   			}
   			else { 
   				$t = 0;
   			}
			
			#compare the score got from different path way and choose the greatest one 
			#diagonal path way
  			$max = $V[$i-1][$j-1] + $t;  
			#parallel path way
  			if ($max < $V[$i][$j-1]) {
    			$max = $V[$i][$j-1];
  			}
  			#vertical path way
  			if ($V[$i-1][$j] > $max) {
    			$max = $V[$i-1][$j];
  			}
  			$V[$i][$j] = $max; 
  		}
	}
	print OUT "\t The similarity between string 1 and string $k is $V[$n][$m]\n";
	
    #add all LCS among these strings together.
	$sum += $V[$n][$m];
}

$average = $sum / $stringnum;

print OUT "\t The average LCS length between the first string and other $stringnum strings with length $n is $average\n";

close (OUT);